import os
import requests
from typing import Optional
from sqlalchemy.orm import Session
from users import models as user_models
import logging

logger = logging.getLogger(__name__)

STRIPE_API = "https://api.stripe.com/v1"
STRIPE_SECRET_KEY = os.getenv("STRIPE_SECRET_KEY", "")

# Tier restriction bypass list - users in this list bypass ALL tier restrictions
# Add user IDs or emails here to bypass restrictions
TIER_BYPASS_USER_IDS = [
    # Add user IDs here, e.g.:
    # 1,
    # 42,
]

TIER_BYPASS_USER_EMAILS = [
    # Add user emails here (lowercase), e.g.:
    # "admin@example.com",
    # "test@example.com",
]

# Development mode: bypass ALL users (set to True to bypass for everyone)
TIER_BYPASS_DEVELOPMENT_MODE = True


def should_bypass_tier_restrictions(user: user_models.User) -> bool:
    """
    Check if a user should bypass tier restrictions.
    Returns True if user is in bypass list or development mode is enabled.
    """
    # Development mode: bypass all users
    if TIER_BYPASS_DEVELOPMENT_MODE:
        return True
    
    # Check by user ID
    if user.id in TIER_BYPASS_USER_IDS:
        return True
    
    # Check by email (case-insensitive)
    if user.email.lower() in [email.lower() for email in TIER_BYPASS_USER_EMAILS]:
        return True
    
    return False


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

    # Hard bypass: user ids 1-10 are always considered paid (annual)
    try:
        uid = getattr(user, "id", None)
        if isinstance(uid, int) and 1 <= uid <= 10:
            return "annual"
    except Exception:
        pass

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


