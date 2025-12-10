
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from db.session import SessionLocal
from . import models, schemas
from typing import List
import json
from core.auth import get_current_user_id
from users import models as user_models
from core.tier import get_user_tier

router = APIRouter(prefix="/workouts", tags=["workouts"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.WorkoutOut)
def create_workout(
    workout: schemas.WorkoutCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    # Enforce free-tier limit: max 1 workout per day (non-draft)
    user = db.query(user_models.User).filter(user_models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    tier = get_user_tier(db, user)
    if tier == "free":
        today_count = (
            db.query(models.Workout)
            .filter(models.Workout.user_id == user_id)
            .filter(models.Workout.is_draft.is_(False))
            .filter(func.date(models.Workout.started_at) == func.current_date())
            .count()
        )
        if today_count >= 1:
            raise HTTPException(
                status_code=403,
                detail={
                    "code": "limit.workouts.daily",
                    "message": "Free plan limit: one workout per day. Upgrade for unlimited.",
                },
            )
    # Store exercises as native JSON (list of dicts); SQLAlchemy JSON will serialize
    exercises_payload = None
    if workout.exercises:
        exercises_payload = [ex.model_dump() for ex in workout.exercises]

    # Delete any existing draft when creating a real workout
    db.query(models.Workout).filter(
        models.Workout.user_id == user_id,
        models.Workout.is_draft == True
    ).delete()

    db_workout = models.Workout(
        user_id=user_id,
        title=workout.title,
        workout_types=workout.workout_types,
        notes=workout.notes,
        exercises=exercises_payload,
        is_draft=False
    )
    db.add(db_workout)
    db.commit()
    db.refresh(db_workout)
    return db_workout

@router.get("/draft", response_model=schemas.WorkoutOut)
def get_draft(db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    """Get the user's current workout draft"""
    draft = db.query(models.Workout).filter(
        models.Workout.user_id == user_id,
        models.Workout.is_draft == True
    ).first()
    
    if not draft:
        raise HTTPException(status_code=404, detail="No draft found")
    
    # Normalize exercises to Python objects
    if isinstance(draft.exercises, str):
        try:
            draft.exercises = json.loads(draft.exercises)
        except (json.JSONDecodeError, TypeError):
            draft.exercises = None
    
    return draft

@router.post("/draft", response_model=schemas.WorkoutOut)
def save_draft(
    workout: schemas.WorkoutCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    """Save or update the workout draft"""
    exercises_payload = None
    if workout.exercises:
        exercises_payload = [ex.model_dump() for ex in workout.exercises]
    
    # Check if draft already exists
    existing_draft = db.query(models.Workout).filter(
        models.Workout.user_id == user_id,
        models.Workout.is_draft == True
    ).first()
    
    if existing_draft:
        # Update existing draft
        existing_draft.title = workout.title
        existing_draft.workout_types = workout.workout_types
        existing_draft.notes = workout.notes
        existing_draft.exercises = exercises_payload
        db.commit()
        db.refresh(existing_draft)
        return existing_draft
    else:
        # Create new draft
        db_draft = models.Workout(
            user_id=user_id,
            title=workout.title,
            workout_types=workout.workout_types,
            notes=workout.notes,
            exercises=exercises_payload,
            is_draft=True
        )
        db.add(db_draft)
        db.commit()
        db.refresh(db_draft)
        return db_draft

@router.get("/", response_model=List[schemas.WorkoutOut])
def get_workouts(db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    workouts = db.query(models.Workout).filter(
        models.Workout.user_id == user_id,
        models.Workout.is_draft == False,  # Exclude drafts from workout list
        models.Workout.deleted_at.is_(None)  # Only get active (non-deleted) workouts
    ).all()
    # Normalize exercises to Python objects
    for workout in workouts:
        if isinstance(workout.exercises, str):
            try:
                workout.exercises = json.loads(workout.exercises)
            except (json.JSONDecodeError, TypeError):
                workout.exercises = None
    return workouts

@router.get("/{workout_id}", response_model=schemas.WorkoutOut)
def get_workout(workout_id: int, db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    workout = db.query(models.Workout).filter(
        models.Workout.id == workout_id,
        models.Workout.user_id == user_id,
        models.Workout.deleted_at.is_(None)  # Only get active workouts
    ).first()
    if not workout:
        raise HTTPException(status_code=404, detail="Workout not found")
    # Normalize exercises to Python objects
    if isinstance(workout.exercises, str):
        try:
            workout.exercises = json.loads(workout.exercises)
        except (json.JSONDecodeError, TypeError):
            workout.exercises = None
    return workout

@router.patch("/{workout_id}", response_model=schemas.WorkoutOut)
def update_workout(
    workout_id: int,
    workout_update: schemas.WorkoutUpdate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    workout = db.query(models.Workout).filter(
        models.Workout.id == workout_id,
        models.Workout.user_id == user_id,
        models.Workout.deleted_at.is_(None)  # Only allow updating active workouts
    ).first()
    
    if not workout:
        raise HTTPException(status_code=404, detail="Workout not found")
    
    # Update fields if provided
    update_data = workout_update.model_dump(exclude_unset=True)
    
    # Handle exercises JSON conversion
    if 'exercises' in update_data and update_data['exercises']:
        update_data['exercises'] = json.dumps([exercise.model_dump() for exercise in update_data['exercises']])
    
    for field, value in update_data.items():
        setattr(workout, field, value)
    
    db.commit()
    db.refresh(workout)
    return workout

@router.delete("/{workout_id}")
def delete_workout(workout_id: int, db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    workout = db.query(models.Workout).filter(
        models.Workout.id == workout_id,
        models.Workout.user_id == user_id,
        models.Workout.deleted_at.is_(None)  # Only allow deleting active workouts
    ).first()
    
    if not workout:
        raise HTTPException(status_code=404, detail="Workout not found")
    
    # Soft delete: set deleted_at timestamp
    from datetime import datetime
    workout.deleted_at = datetime.utcnow()
    db.commit()
    return {"message": "Workout deleted successfully"}