import os
from fastapi import APIRouter, Depends, HTTPException, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
import requests
from db.session import SessionLocal
from . import models
from users import models as user_models
from core.auth import get_current_user_id

# ------------------------------------------------------------------
# Router
# ------------------------------------------------------------------
router = APIRouter(prefix="/stripe", tags=["stripe"])

# ------------------------------------------------------------------
# Stripe configuration
# ------------------------------------------------------------------
STRIPE_SECRET_KEY = os.getenv("STRIPE_SECRET_KEY")
STRIPE_API = "https://api.stripe.com/v1"

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
        form = {
            "mode": "subscription",
            "success_url": f"{os.getenv('DOMAIN')}/success",
            "cancel_url": f"{os.getenv('DOMAIN')}/cancel",
            "client_reference_id": str(user_id),
            "metadata[tier]": tier,
            "line_items[0][price]": price_id,
            "line_items[0][quantity]": "1",
        }
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
    # NOTE: In dev we're not verifying signature to avoid SDK dependency
    try:
        event = request.json()
    except Exception:
        import json
        event = json.loads(payload)

    # ------------------------------------------------------------------
    # Handle relevant events
    # ------------------------------------------------------------------
    event_type = event.get("type")
    if event_type == "checkout.session.completed":
        # Session just finished → create a pending record (optional)
        session = event["data"]["object"]
        await _handle_session_completed(session, db)

    elif event_type == "invoice.paid":
        # Payment succeeded → grant access
        invoice = event["data"]["object"]
        await _grant_subscription(invoice, db)

    elif event_type in ("invoice.payment_failed", "customer.subscription.deleted"):
        # Revoke access
        invoice = event["data"]["object"]
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
        session = stripe.billing_portal.Session.create(
            customer=user.stripe_customer_id,
            return_url=f"{os.getenv('DOMAIN')}/Account",
        )
        return {"url": session.url}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ------------------------------------------------------------------
# Helper: session completed (store customer + tier)
# ------------------------------------------------------------------
async def _handle_session_completed(session_obj, db: Session):
    customer_id = session_obj.customer
    tier = session_obj.metadata.get("tier")
    client_reference_id = session_obj.client_reference_id  # our user_id

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