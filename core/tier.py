import os
import requests
from typing import Optional
from sqlalchemy.orm import Session
from users import models as user_models
import logging

logger = logging.getLogger(__name__)

STRIPE_API = "https://api.stripe.com/v1"
STRIPE_SECRET_KEY = os.getenv("STRIPE_SECRET_KEY", "")


def _map_price_to_tier(price_id: Optional[str]) -> str:
    if not price_id:
        return "free"
    if price_id == os.getenv("PRICE_MONTHLY"):
        return "monthly"
    if price_id == os.getenv("PRICE_ANNUAL"):
        return "annual"
    return "free"


def get_user_tier(db: Session, user: user_models.User) -> str:
    """
    Determine the user's tier using (in order of precedence):
      1) Dev override via env flags
      2) Stripe active subscription price → tier mapping
      3) Default to 'free'
    """
    # Default
    tier = "free"

    # Dev override
    try:
        if os.getenv("DEV_ENABLE_PAID_OVERRIDE", "false").lower() == "true":
            raw_ids = os.getenv("DEV_PAID_USER_IDS", "")
            paid_ids = set(
                int(x.strip()) for x in raw_ids.split(",") if x.strip().isdigit()
            )
            if not paid_ids:
                paid_ids = {1}
            if user.id in paid_ids or (getattr(user, "username", "").lower() == "calvin"):
                tier = os.getenv("DEV_FORCE_TIER", "annual")
                return tier
    except Exception:
        pass

    # Stripe subscription check
    try:
        if getattr(user, "stripe_customer_id", None):
            r = requests.get(
                f"{STRIPE_API}/subscriptions",
                params={
                    "customer": user.stripe_customer_id,
                    "status": "all",
                    "expand[]": "data.items.data.price",
                },
                auth=(STRIPE_SECRET_KEY, ""),
                timeout=10,
            )
            if r.status_code < 400:
                data = r.json().get("data", [])
                active_sub = next(
                    (s for s in data if s.get("status") in ("active", "trialing", "past_due")),
                    None,
                )
                if active_sub:
                    items = (active_sub.get("items") or {}).get("data") or []
                    price_id = items[0].get("price", {}).get("id") if items else None
                    tier = _map_price_to_tier(price_id)
    except Exception as e:
        logger.warning(f"Failed to determine tier for user {user.id}: {e}")

    return tier


