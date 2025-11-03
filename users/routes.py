from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from db.session import SessionLocal
from core.auth import hash_password, verify_password, create_access_token, get_current_user_id
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

    # Check if username is already taken
    existing_username = db.query(models.User).filter(models.User.username == user.username).first()
    if existing_username:
        raise HTTPException(status_code=400, detail="Username already taken")

    # Hash the password before storing
    user_data = user.model_dump()
    password = user_data.pop('password')
    user_data['password_hash'] = hash_password(password)
    
    new_user = models.User(**user_data)

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    # Create access token
    access_token = create_access_token(data={"user_id": new_user.id})

    return schemas.UserResponse(
        user=schemas.UserBase.model_validate(new_user),
        access_token=access_token
    )

@router.post("/login", response_model=schemas.UserResponse)
def login(credentials: schemas.UserLogin, db: Session = Depends(get_db)):
    # Find user by email
    user = db.query(models.User).filter(models.User.email == credentials.email).first()
    
    if not user:
        raise HTTPException(status_code=401, detail="No user found with this email")
    
    # Verify password
    if not verify_password(credentials.password, user.password_hash):
        raise HTTPException(status_code=401, detail="This password is incorrect")
    
    # Update last login
    from datetime import datetime
    user.last_login = datetime.utcnow()
    db.commit()
    
    # Create access token
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


@router.get("/me", response_model=schemas.UserWithTier)
async def get_current_user(user_id: int = Depends(get_current_user_id), db: Session = Depends(get_db)):
    """Get the currently authenticated user along with subscription tier."""
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    tier = "free"

    # Dev-only override: treat selected users as paid without Stripe
    try:
        if os.getenv("DEV_ENABLE_PAID_OVERRIDE", "false").lower() == "true":
            raw_ids = os.getenv("DEV_PAID_USER_IDS", "")
            paid_ids = set(int(x.strip()) for x in raw_ids.split(",") if x.strip().isdigit())
            if not paid_ids:
                paid_ids = {1}
            if user.id in paid_ids or (getattr(user, "username", "").lower() == "calvin"):
                tier = os.getenv("DEV_FORCE_TIER", "annual")
                data = schemas.UserWithTier.model_validate(user).model_dump()
                data["tier"] = tier
                return data
    except Exception:
        pass
    try:
        # If we know the Stripe customer, check their active subscription via REST
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
                def is_active(s: dict) -> bool:
                    return s.get("status") in ("active", "trialing", "past_due")
                active_sub = next((s for s in data if is_active(s)), None)
                if active_sub:
                    items = (active_sub.get("items") or {}).get("data") or []
                    price = items[0].get("price") if items else None
                    price_id = price.get("id") if price else None
                    tier = _map_price_to_tier(price_id)
    except Exception as e:
        logger.warning(f"Failed to determine tier for user {user_id}: {e}")

    data = schemas.UserWithTier.model_validate(user).model_dump()
    data["tier"] = tier
    return data

@router.get("/{user_id}", response_model=schemas.UserBase)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    logger.debug(f"Query result for user_id={user_id}: {user}")
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.patch("/{user_id}", response_model=schemas.UserBase)
def update_user(user_id: int, user_settings: schemas.UserSettings, 
                current_user_id: int = Depends(get_current_user_id),
                db: Session = Depends(get_db)):
    # Check if the user is updating their own settings
    if user_id != current_user_id:
        raise HTTPException(status_code=403, detail="Not authorized to update this user")
    
    user = db.query(models.User).get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Merge new settings with existing settings to preserve fields not being updated
    existing_settings = user.settings or {}
    new_settings = user_settings.model_dump(exclude_unset=True)
    merged_settings = {**existing_settings, **new_settings}
    
    user.settings = merged_settings
    db.commit()
    db.refresh(user)
    return user

@router.post("/change-password")
def change_password(
    password_data: schemas.PasswordChange,
    current_user_id: int = Depends(get_current_user_id),
    db: Session = Depends(get_db)
):
    """Change the password for the currently authenticated user."""
    user = db.query(models.User).filter(models.User.id == current_user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Verify old password
    if not verify_password(password_data.old_password, user.password_hash):
        raise HTTPException(status_code=401, detail="Current password is incorrect")
    
    # Hash and set new password
    user.password_hash = hash_password(password_data.new_password)
    db.commit()
    
    return {"message": "Password changed successfully"}

