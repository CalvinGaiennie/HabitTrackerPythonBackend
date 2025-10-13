from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from db.session import SessionLocal
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/users", tags=["users"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/create", response_model=schemas.UserBase)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(models.User).filter(models.User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exist")

    # Hash the password before storing (you should use proper password hashing)
    user_data = user.dict()
    password = user_data.pop('password')
    user_data['password_hash'] = password  # TODO: Use proper hashing like bcrypt
    
    new_user = models.User(**user_data)

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user

@router.get("/{user_id}", response_model=schemas.UserBase)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    logger.debug(f"Query result for user_id={user_id}: {user}")
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.patch("/{user_id}", response_model=schemas.UserBase)
def update_user(user_id: int, user_settings: schemas.UserSettings, db: Session = Depends(get_db)):
    user = db.query(models.User).get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Merge new settings with existing settings to preserve fields not being updated
    existing_settings = user.settings or {}
    new_settings = user_settings.dict(exclude_unset=True)
    merged_settings = {**existing_settings, **new_settings}
    
    user.settings = merged_settings
    db.commit()
    db.refresh(user)
    return user


