from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from db.session import SessionLocal

router = APIRouter(prefix="/exercises", tags=["exercises"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.ExerciseCreate)
def create_exercise(exercise: schemas.ExerciseCreate, db: Session = Depends(get_db)):
    db_exercise = models.ExerciseFull(**exercise.model_dump())
    db.add(db_exercise)
    db.commit()
    db.refresh(db_exercise)
    return db_exercise 

@router.get("/", response_model=list[schemas.ExerciseCreate])
def get_exercises(db: Session = Depends(get_db)):
    return db.query(models.ExerciseFull).all()