from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from db.session import SessionLocal
from core.auth import get_current_user_id

router = APIRouter(prefix="/exercises", tags=["exercises"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.ExerciseCreate)
def create_exercise(
    exercise: schemas.ExerciseCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    # Exclude user_id from model_dump to avoid duplicate argument error
    # since we're also passing user_id=user_id explicitly
    exercise_dict = exercise.model_dump()
    exercise_dict.pop('user_id', None)  # Remove user_id if present
    db_exercise = models.ExerciseFull(**exercise_dict, user_id=user_id)
    db.add(db_exercise)
    db.commit()
    db.refresh(db_exercise)
    return db_exercise 

@router.get("/", response_model=list[schemas.ExerciseCreate])
def get_exercises(db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    return db.query(models.ExerciseFull).filter(models.ExerciseFull.user_id == user_id).all()