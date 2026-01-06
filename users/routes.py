from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from . import models, schemas
from db.session import SessionLocal
from core.auth import hash_password, verify_password, create_access_token, get_current_user_id
from core.tier import get_user_tier, should_bypass_tier_restrictions
import logging
import os
import requests

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/users", tags=["users"])
STRIPE_SECRET_KEY = os.getenv("STRIPE_SECRET_KEY")
STRIPE_API = "https://api.stripe.com/v1"

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/create", response_model=schemas.UserResponse)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(models.User).filter(models.User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")

    existing_username = db.query(models.User).filter(models.User.username == user.username).first()
    if existing_username:
        raise HTTPException(status_code=400, detail="Username already taken")

    user_data = user.model_dump()
    password = user_data.pop('password')
    user_data['password_hash'] = hash_password(password)
    
    new_user = models.User(**user_data)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    access_token = create_access_token(data={"user_id": new_user.id})

    return schemas.UserResponse(
        user=schemas.UserBase.model_validate(new_user),
        access_token=access_token
    )

@router.post("/login", response_model=schemas.UserResponse)
def login(credentials: schemas.UserLogin, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(func.lower(models.User.email) == credentials.email.lower()).first()
    
    if not user:
        raise HTTPException(status_code=401, detail="No user found with this email")
    
    if not verify_password(credentials.password, user.password_hash):
        raise HTTPException(status_code=401, detail="This password is incorrect")
    
    from datetime import datetime
    user.last_login = datetime.utcnow()
    db.commit()
    
    access_token = create_access_token(data={"user_id": user.id})
    
    return schemas.UserResponse(
        user=schemas.UserBase.model_validate(user),
        access_token=access_token
    )

def _map_price_to_tier(price_id: str | None) -> str:
    if not price_id:
        return "free"
    if price_id == os.getenv("PRICE_MONTHLY"):
        return "monthly"
    if price_id == os.getenv("PRICE_ANNUAL"):
        return "annual"
    return "free"

# === UPDATED: /me now returns FULL settings including homePageAnalytics ===
@router.get("/me", response_model=schemas.UserWithSettings)
async def get_current_user(user_id: int = Depends(get_current_user_id), db: Session = Depends(get_db)):
    """Get the currently authenticated user with full settings and tier."""
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    tier = "free"

    # Hard bypass: user ids 1-10 are always considered paid (annual)
    if 1 <= user.id <= 10:
        return {
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "settings": user.settings or {},
            "tier": "annual"
        }

    # Dev override
    try:
        if os.getenv("DEV_ENABLE_PAID_OVERRIDE", "false").lower() == "true":
            raw_ids = os.getenv("DEV_PAID_USER_IDS", "")
            paid_ids = set(int(x.strip()) for x in raw_ids.split(",") if x.strip().isdigit())
            if not paid_ids:
                paid_ids = {1}
            if user.id in paid_ids or (getattr(user, "username", "").lower() == "calvin"):
                tier = os.getenv("DEV_FORCE_TIER", "annual")
    except Exception:
        pass

    # Stripe subscription check
    try:
        if user.stripe_customer_id:
            r = requests.get(
                f"{STRIPE_API}/subscriptions",
                params={
                    "customer": user.stripe_customer_id,
                    "status": "all",
                    "expand[]": "data.items.data.price",
                },
                auth=(STRIPE_SECRET_KEY, ""),
            )
            if r.status_code < 400:
                data = r.json().get("data", [])
                active_sub = next((s for s in data if s.get("status") in ("active", "trialing", "past_due")), None)
                if active_sub:
                    items = (active_sub.get("items") or {}).get("data") or []
                    price_id = items[0].get("price", {}).get("id") if items else None
                    tier = _map_price_to_tier(price_id)
    except Exception as e:
        logger.warning(f"Failed to determine tier for user {user_id}: {e}")

    # === RETURN FULL USER WITH ALL SETTINGS (including homePageAnalytics) ===
    return {
        "id": user.id,
        "email": user.email,
        "username": user.username,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "settings": user.settings or {},  # ← This includes homePageAnalytics
        "tier": tier
    }

@router.get("/{user_id}", response_model=schemas.UserBase)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# === Convenience endpoint: PATCH /users/me ===
@router.patch("/me", response_model=schemas.UserWithSettings)
def update_current_user(
    user_settings: schemas.UserSettings,
    current_user_id: int = Depends(get_current_user_id),
    db: Session = Depends(get_db)
):
    """Update the current user's settings using /users/me endpoint."""
    logger.info(f"🔵 PATCH /users/me called by user_id={current_user_id}")
    
    user = db.query(models.User).filter(models.User.id == current_user_id).first()
    if not user:
        logger.error(f"❌ User {current_user_id} not found")
        raise HTTPException(status_code=404, detail="User not found")
    
    existing_settings = user.settings or {}
    new_settings = user_settings.model_dump(exclude_unset=True)
    
    logger.info(f"📥 Received settings update:")
    logger.info(f"   enabledPages: {new_settings.get('enabledPages')}")
    logger.info(f"   homePageLayout: {len(new_settings.get('homePageLayout', []))} sections")
    if 'homePageLayout' in new_settings and new_settings['homePageLayout']:
        for idx, section in enumerate(new_settings['homePageLayout']):
            logger.info(f"     Section {idx}: '{section.get('section')}' with {len(section.get('metricIds', []))} metrics: {section.get('metricIds')}")
    logger.info(f"   homePageAnalytics: {len(new_settings.get('homePageAnalytics', []))} charts")
    logger.info(f"📋 Existing settings: {existing_settings}")

    # Enforce free-tier: only 1 homepage chart allowed
    # Check if user bypasses tier restrictions
    if should_bypass_tier_restrictions(user):
        # User bypasses restrictions - skip tier limit check
        pass
    else:
        tier = get_user_tier(db, user)
        if tier == "free":
            if "homePageAnalytics" in new_settings:
                charts = new_settings.get("homePageAnalytics") or []
                if isinstance(charts, list) and len(charts) > 1:
                    logger.warning(f"⚠️ Free tier limit: user tried to add {len(charts)} charts")
                    raise HTTPException(
                        status_code=403,
                        detail={
                            "code": "limit.homepage.charts",
                            "message": "Free plan limit: one homepage chart. Upgrade to add more.",
                        },
                    )
    
    merged_settings = {**existing_settings, **new_settings}
    logger.info(f"💾 Merged settings: {merged_settings}")
    
    user.settings = merged_settings
    db.commit()
    db.refresh(user)
    
    logger.info(f"✅ Settings saved successfully for user {user.id}")
    logger.info(f"📤 Returning settings: {user.settings}")

    return {
        "id": user.id,
        "email": user.email,
        "username": user.username,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "settings": user.settings,
        "tier": "free"  # You can compute tier here too if needed
    }

# === UPDATED: Return full settings after update ===
@router.patch("/{user_id}", response_model=schemas.UserWithSettings)
def update_user(
    user_id: int,
    user_settings: schemas.UserSettings, 
    current_user_id: int = Depends(get_current_user_id),
    db: Session = Depends(get_db)
):
    logger.warning(f"⚠️ PATCH /users/{{user_id}} called with user_id={user_id}, current_user_id={current_user_id}")
    logger.warning(f"   This route should not be used - use /users/me instead")
    if user_id != current_user_id:
        logger.error(f"❌ Authorization failed: user_id {user_id} != current_user_id {current_user_id}")
        raise HTTPException(status_code=403, detail="Not authorized to update this user")
    
    user = db.query(models.User).get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    existing_settings = user.settings or {}
    new_settings = user_settings.model_dump(exclude_unset=True)

    # Enforce free-tier: only 1 homepage chart allowed
    # Check if user bypasses tier restrictions
    if should_bypass_tier_restrictions(user):
        # User bypasses restrictions - skip tier limit check
        pass
    else:
        tier = get_user_tier(db, user)
        if tier == "free":
            if "homePageAnalytics" in new_settings:
                charts = new_settings.get("homePageAnalytics") or []
                if isinstance(charts, list) and len(charts) > 1:
                    raise HTTPException(
                        status_code=403,
                        detail={
                            "code": "limit.homepage.charts",
                            "message": "Free plan limit: one homepage chart. Upgrade to add more.",
                        },
                    )
    merged_settings = {**existing_settings, **new_settings}
    
    user.settings = merged_settings
    db.commit()
    db.refresh(user)

    return {
        "id": user.id,
        "email": user.email,
        "username": user.username,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "settings": user.settings,
        "tier": "free"  # You can compute tier here too if needed
    }

@router.post("/change-password")
def change_password(
    password_data: schemas.PasswordChange,
    current_user_id: int = Depends(get_current_user_id),
    db: Session = Depends(get_db)
):
    user = db.query(models.User).filter(models.User.id == current_user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if not verify_password(password_data.old_password, user.password_hash):
        raise HTTPException(status_code=401, detail="Current password is incorrect")
    
    user.password_hash = hash_password(password_data.new_password)
    db.commit()
    
    return {"message": "Password changed successfully"}