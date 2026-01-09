from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from db.session import SessionLocal
from core.auth import get_current_user_id

router = APIRouter(prefix="/foods", tags=["foods"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.FoodOut)
def create_food(
    food: schemas.FoodCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    # Check for duplicate name to return a clear 409 instead of generic 500
    existing = (
        db.query(models.Food)
        .filter(models.Food.user_id == user_id, models.Food.name == food.name)
        .first()
    )
    if existing:
        raise HTTPException(status_code=409, detail="A food with this name already exists.")

    payload = {**food.model_dump(), "user_id": user_id}
    db_food = models.Food(**payload)
    db.add(db_food)
    db.commit()
    db.refresh(db_food)
    return db_food

@router.get("/", response_model=list[schemas.FoodOut])
def get_foods(db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    return db.query(models.Food).filter(models.Food.user_id == user_id).all()

@router.put("/{food_id}", response_model=schemas.FoodOut)
def update_food(
    food_id: int,
    food_update: schemas.FoodUpdate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    food = db.query(models.Food).filter(
        models.Food.id == food_id,
        models.Food.user_id == user_id
    ).first()
    
    if not food:
        raise HTTPException(status_code=404, detail="Food not found")
    
    # Update only provided fields
    update_data = food_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(food, field, value)
    
    db.commit()
    db.refresh(food)
    return food

@router.put("/{food_id}", response_model=schemas.FoodOut)
def update_food(
    food_id: int,
    food_update: schemas.FoodUpdate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    food = db.query(models.Food).filter(
        models.Food.id == food_id,
        models.Food.user_id == user_id
    ).first()
    
    if not food:
        raise HTTPException(status_code=404, detail="Food not found")
    
    # Update only provided fields
    update_data = food_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(food, field, value)
    
    db.commit()
    db.refresh(food)
    return food
