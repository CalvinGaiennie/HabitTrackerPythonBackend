from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from db.session import SessionLocal
from . import models, schemas
from datetime import date
from typing import Optional
from core.auth import get_current_user_id
from users import models as user_models
from core.tier import get_user_tier

router = APIRouter(prefix="/food_entries", tags=["food_entries"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.FoodEntryOut)
def create_food_entry(
    food_entry: schemas.FoodEntryCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    # Enforce free-tier limit: max 3 food logs per day
    user = db.query(user_models.User).filter(user_models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    tier = get_user_tier(db, user)
    if tier == "free":
        day_count = (
            db.query(models.FoodEntry)
            .filter(models.FoodEntry.user_id == user_id)
            .filter(models.FoodEntry.log_date == food_entry.log_date)
            .count()
        )
        if day_count >= 3:
            raise HTTPException(
                status_code=403,
                detail={
                    "code": "limit.food_entries.daily",
                    "message": "Free plan limit: max 3 food logs per day. Upgrade to add more.",
                },
            )
    payload = food_entry.model_dump()
    payload["user_id"] = user_id
    db_entry = models.FoodEntry(**payload)
    db.add(db_entry)
    db.commit()
    db.refresh(db_entry)
    return db_entry

@router.get("/", response_model=list[schemas.FoodEntryOut])
def get_food_entries(
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    log_date: Optional[date] = None,
    food_id: Optional[int] = Query(None, description="Filter by specific food"),
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    query = db.query(models.FoodEntry).filter(models.FoodEntry.user_id == user_id)
    if food_id is not None:
        query = query.filter(models.FoodEntry.food_id == food_id)
    if log_date:
        query = query.filter(models.FoodEntry.log_date == log_date)
    else:
        if start_date:
            query = query.filter(models.FoodEntry.log_date >= start_date)
        if end_date:
            query = query.filter(models.FoodEntry.log_date <= end_date)
    return query.order_by(models.FoodEntry.log_date.desc(), models.FoodEntry.created_at.desc()).all()

@router.put("/{entry_id}", response_model=schemas.FoodEntryOut)
def update_food_entry(
    entry_id: int,
    update: schemas.FoodEntryCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    entry = db.query(models.FoodEntry).filter(
        models.FoodEntry.id == entry_id, models.FoodEntry.user_id == user_id
    ).first()
    if not entry:
        raise HTTPException(status_code=404, detail="Food entry not found")
    for field, value in update.model_dump(exclude_unset=True).items():
        if field == "user_id":
            continue
        setattr(entry, field, value)
    db.commit()
    db.refresh(entry)
    return entry

@router.delete("/{entry_id}")
def delete_food_entry(
    entry_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    entry = db.query(models.FoodEntry).filter(
        models.FoodEntry.id == entry_id, models.FoodEntry.user_id == user_id
    ).first()
    if not entry:
        raise HTTPException(status_code=404, detail="Food entry not found")
    db.delete(entry)
    db.commit()
    return {"message": "Food entry deleted"}