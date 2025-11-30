import os
from fastapi import APIRouter, Depends, HTTPException, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
import requests
from db.session import SessionLocal
from . import models
from users import models as user_models
from core.auth import get_current_user_id
from typing import Any, Dict
import stripe

# ------------------------------------------------------------------
# Router
# ------------------------------------------------------------------
router = APIRouter(prefix="/stripe", tags=["stripe"])

# ------------------------------------------------------------------
# Stripe configuration
# ------------------------------------------------------------------
STRIPE_SECRET_KEY = os.getenv("STRIPE_SECRET_KEY")
STRIPE_API = "https://api.stripe.com/v1"
STRIPE_WEBHOOK_SECRET = os.getenv("STRIPE_WEBHOOK_SECRET")

if STRIPE_SECRET_KEY:
    stripe.api_key = STRIPE_SECRET_KEY

# ------------------------------------------------------------------
# DB dependency
# ------------------------------------------------------------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# ------------------------------------------------------------------
# 1. Create Checkout Session (monthly / annual)
# ------------------------------------------------------------------
@router.post("/create-checkout-session")
async def create_checkout_session(
    tier: str = "monthly",
    user_id: int = Depends(get_current_user_id),
    db: Session = Depends(get_db),
):
    """
    tier: "monthly" or "annual"
    Returns { "id": "<checkout_session_id>" }
    """
    price_map = {
        "monthly": os.getenv("PRICE_MONTHLY"),
        "annual":  os.getenv("PRICE_ANNUAL"),
    }

    price_id = price_map.get(tier)
    if not price_id:
        raise HTTPException(status_code=400, detail="Invalid tier")

    try:
        # If the user already has a Stripe customer, attach it so they don't create duplicates
        user = db.query(user_models.User).filter(user_models.User.id == user_id).first()
        existing_customer_id = getattr(user, "stripe_customer_id", None) if user else None

        form = {
            "mode": "subscription",
            "success_url": f"{os.getenv('DOMAIN')}/success",
            "cancel_url": f"{os.getenv('DOMAIN')}/cancel",
            "client_reference_id": str(user_id),
            "metadata[tier]": tier,
            # Persist tier on the subscription for later lookups
            "subscription_data[metadata][tier]": tier,
            "line_items[0][price]": price_id,
            "line_items[0][quantity]": "1",
        }
        if existing_customer_id:
            form["customer"] = existing_customer_id

        r = requests.post(f"{STRIPE_API}/checkout/sessions", data=form, auth=(STRIPE_SECRET_KEY, ""))
        if r.status_code >= 400:
            raise HTTPException(status_code=500, detail=r.text)
        data = r.json()
        return {"id": data.get("id")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ------------------------------------------------------------------
# 2. Webhook – receive Stripe events
# ------------------------------------------------------------------
@router.post("/webhook")
async def stripe_webhook(request: Request, db: Session = Depends(get_db)):
    payload = await request.body()
    # If a webhook secret is configured, verify the signature
    if STRIPE_WEBHOOK_SECRET:
        sig_header = request.headers.get("stripe-signature", "")
        try:
            event = stripe.Webhook.construct_event(
                payload=payload,
                sig_header=sig_header,
                secret=STRIPE_WEBHOOK_SECRET,
            )
        except stripe.error.SignatureVerificationError:
            raise HTTPException(status_code=400, detail="Invalid Stripe signature")
        except Exception as e:
            raise HTTPException(status_code=400, detail=f"Webhook error: {e}")
    else:
        # Fallback without verification (dev only)
        try:
            event = await request.json()
        except Exception:
            import json
            event = json.loads(payload)

    # ------------------------------------------------------------------
    # Handle relevant events
    # ------------------------------------------------------------------
    event_type = event.get("type")
    if event_type == "checkout.session.completed":
        # Session just finished → create a pending record (optional)
        session_obj = event.get("data", {}).get("object") or {}
        await _handle_session_completed(session_obj, db)

    elif event_type == "invoice.paid":
        # Payment succeeded → grant access
        invoice = event.get("data", {}).get("object") or {}
        await _grant_subscription(invoice, db)

    elif event_type in ("invoice.payment_failed", "customer.subscription.deleted"):
        # Revoke access
        invoice = event.get("data", {}).get("object") or {}
        await _revoke_subscription(invoice, db)

    return JSONResponse({"status": "success"})


# ------------------------------------------------------------------
# 3. Customer billing portal session
# ------------------------------------------------------------------
@router.post("/create-portal-session")
async def create_portal_session(
    user_id: int = Depends(get_current_user_id),
    db: Session = Depends(get_db),
):
    user = db.query(user_models.User).filter(user_models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    if not user.stripe_customer_id:
        raise HTTPException(status_code=400, detail="No Stripe customer linked")

    try:
        form = {
            "customer": user.stripe_customer_id,
            "return_url": f"{os.getenv('DOMAIN')}/Account",
        }
        r = requests.post(f"{STRIPE_API}/billing_portal/sessions", data=form, auth=(STRIPE_SECRET_KEY, ""))
        if r.status_code >= 400:
            raise HTTPException(status_code=500, detail=r.text)
        data = r.json()
        return {"url": data.get("url")}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ------------------------------------------------------------------
# Helper: session completed (store customer + tier)
# ------------------------------------------------------------------
async def _handle_session_completed(session_obj, db: Session):
    # session_obj comes as a dict from the webhook payload
    customer_id = session_obj.get("customer")
    metadata: Dict[str, Any] = session_obj.get("metadata") or {}
    tier = metadata.get("tier")
    client_reference_id = session_obj.get("client_reference_id")  # our user_id

    # Link Stripe customer to our user
    try:
        if client_reference_id:
            user = db.query(user_models.User).filter(user_models.User.id == int(client_reference_id)).first()
            if user and not user.stripe_customer_id:
                user.stripe_customer_id = customer_id
                db.commit()
    except Exception:
        pass


# ------------------------------------------------------------------
# Helper: grant subscription (invoice.paid)
# ------------------------------------------------------------------
async def _grant_subscription(invoice, db: Session):
    customer_id = invoice.customer
    # Find the subscription to get the tier (or use metadata from session)
    sub_id = invoice.get("subscription") if isinstance(invoice, dict) else getattr(invoice, "subscription", None)
    tier = "monthly"
    if sub_id:
        r = requests.get(f"{STRIPE_API}/subscriptions/{sub_id}", auth=(STRIPE_SECRET_KEY, ""))
        if r.status_code < 400:
            subscription = r.json()
            metadata = subscription.get("metadata") or {}
            tier = metadata.get("tier") or "monthly"

    stripe_customer = (
        db.query(models.StripeCustomer)
        .filter(models.StripeCustomer.stripe_customer_id == customer_id)
        .first()
    )
    if stripe_customer:
        stripe_customer.tier = tier
        stripe_customer.active = True
        stripe_customer.subscription_id = invoice.subscription
        db.commit()
        print(f"GRANT {tier.upper()} to customer {customer_id}")
    else:
        # Fallback: create on the fly
        new_c = models.StripeCustomer(
            stripe_customer_id=customer_id,
            tier=tier,
            active=True,
            subscription_id=invoice.subscription,
        )
        db.add(new_c)
        db.commit()


# ------------------------------------------------------------------
# Helper: revoke subscription
# ------------------------------------------------------------------
async def _revoke_subscription(invoice, db: Session):
    customer_id = invoice.customer
    stripe_customer = (
        db.query(models.StripeCustomer)
        .filter(models.StripeCustomer.stripe_customer_id == customer_id)
        .first()
    )
    if stripe_customer:
        stripe_customer.active = False
        db.commit()
        print(f"REVOKE access from customer {customer_id}")