from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session 
from . import models, schemas 
from db.session import SessionLocal

router = APIRouter(prefix="/foods", tags=["foods"])

def get_db():
    db = SessionLocal()
    try:
        yeild db
    finally:
        db.close()

@router.post("/", response_model=schemas.FoodCreate)
def create_food(food: schemas.FoodCreate, db: Session = Depends(get_db)):
    db_exercise = models.Food(**food.model_dump())
    db.add(db_food)
    db.commit()
    db.refresh(db_food)
    return db_food

@router.get("/", response_model=list[schemas.FoodCreate])
def get_foods(db: Session = Depends(get_db)):
    return db.query(models.Food).all()