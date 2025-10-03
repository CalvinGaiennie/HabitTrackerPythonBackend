
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.session import SessionLocal
from . import models, schemas
from typing import List
import json

router = APIRouter(prefix="/workouts", tags=["workouts"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.WorkoutOut)
def create_workout(workout: schemas.WorkoutCreate, db: Session = Depends(get_db)):
    # Convert exercises to JSON for storage
    exercises_json = None
    if workout.exercises:
        exercises_json = json.dumps([exercise.dict() for exercise in workout.exercises])
    
    db_workout = models.Workout(
        user_id=1,  # TODO: Get from auth
        title=workout.title,
        workout_types=workout.workout_types,
        notes=workout.notes,
        exercises=exercises_json
    )
    db.add(db_workout)
    db.commit()
    db.refresh(db_workout)
    return db_workout

@router.get("/", response_model=List[schemas.WorkoutOut])
def get_workouts(db: Session = Depends(get_db)):
    workouts = db.query(models.Workout).filter(models.Workout.user_id == 1).all()
    return workouts

@router.get("/{workout_id}", response_model=schemas.WorkoutOut)
def get_workout(workout_id: int, db: Session = Depends(get_db)):
    workout = db.query(models.Workout).filter(
        models.Workout.id == workout_id,
        models.Workout.user_id == 1
    ).first()
    if not workout:
        raise HTTPException(status_code=404, detail="Workout not found")
    return workout

@router.patch("/{workout_id}", response_model=schemas.WorkoutOut)
def update_workout(workout_id: int, workout_update: schemas.WorkoutUpdate, db: Session = Depends(get_db)):
    workout = db.query(models.Workout).filter(
        models.Workout.id == workout_id,
        models.Workout.user_id == 1
    ).first()
    
    if not workout:
        raise HTTPException(status_code=404, detail="Workout not found")
    
    # Update fields if provided
    update_data = workout_update.dict(exclude_unset=True)
    
    # Handle exercises JSON conversion
    if 'exercises' in update_data and update_data['exercises']:
        update_data['exercises'] = json.dumps([exercise.dict() for exercise in update_data['exercises']])
    
    for field, value in update_data.items():
        setattr(workout, field, value)
    
    db.commit()
    db.refresh(workout)
    return workout

@router.delete("/{workout_id}")
def delete_workout(workout_id: int, db: Session = Depends(get_db)):
    workout = db.query(models.Workout).filter(
        models.Workout.id == workout_id,
        models.Workout.user_id == 1
    ).first()
    
    if not workout:
        raise HTTPException(status_code=404, detail="Workout not found")
    
    db.delete(workout)
    db.commit()
    return {"message": "Workout deleted successfully"}