from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from db.session import SessionLocal

router = APIRouter(prefix="/foods", tags=["foods"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.FoodOut)
def create_food(food: schemas.FoodCreate, db: Session = Depends(get_db)):
    # Check for duplicate name to return a clear 409 instead of generic 500
    existing = db.query(models.Food).filter(models.Food.name == food.name).first()
    if existing:
        raise HTTPException(status_code=409, detail="A food with this name already exists.")

    db_food = models.Food(**food.model_dump())
    db.add(db_food)
    db.commit()
    db.refresh(db_food)
    return db_food

@router.get("/", response_model=list[schemas.FoodOut])
def get_foods(db: Session = Depends(get_db)):
    return db.query(models.Food).all()


@router.get("/", response_model=list[schemas.FoodEntry])
def get_todays_food_entries(db: Session = Depends(get_db)):
    return db.query(models.Food).all()