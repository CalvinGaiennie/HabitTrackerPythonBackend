from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import time as dt_time
from . import models, schemas
from db.session import SessionLocal
from core.auth import get_current_user_id

router = APIRouter(prefix="/reminders", tags=["reminders"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/", response_model=list[schemas.ReminderOut])
def get_reminders(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id)
):
    """Get all reminders for the current user"""
    reminders = (
        db.query(models.Reminder)
        .filter(models.Reminder.user_id == user_id)
        .all()
    )
    # Convert Time objects to strings for serialization
    result = []
    for reminder in reminders:
        reminder_dict = {
            "id": reminder.id,
            "user_id": reminder.user_id,
            "time": reminder.time.strftime("%H:%M"),
            "is_enabled": reminder.is_enabled,
            "created_at": reminder.created_at,
            "updated_at": reminder.updated_at
        }
        result.append(schemas.ReminderOut(**reminder_dict))
    return result

@router.get("/{reminder_id}", response_model=schemas.ReminderOut)
def get_reminder(
    reminder_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id)
):
    """Get a specific reminder by ID"""
    reminder = (
        db.query(models.Reminder)
        .filter(models.Reminder.id == reminder_id, models.Reminder.user_id == user_id)
        .first()
    )
    
    if not reminder:
        raise HTTPException(status_code=404, detail="Reminder not found")
    
    # Convert Time object to string for serialization
    reminder_dict = {
        "id": reminder.id,
        "user_id": reminder.user_id,
        "time": reminder.time.strftime("%H:%M"),
        "is_enabled": reminder.is_enabled,
        "created_at": reminder.created_at,
        "updated_at": reminder.updated_at
    }
    return schemas.ReminderOut(**reminder_dict)

@router.post("/", response_model=schemas.ReminderOut)
def create_reminder(
    reminder: schemas.ReminderCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id)
):
    """Create a new reminder"""
    # Ensure user_id matches the authenticated user
    if reminder.user_id != user_id:
        raise HTTPException(
            status_code=403,
            detail="Cannot create reminder for another user"
        )
    
    # Parse time string to Time object
    time_parts = reminder.time.split(':')
    time_obj = dt_time(int(time_parts[0]), int(time_parts[1]))
    
    db_reminder = models.Reminder(
        user_id=reminder.user_id,
        time=time_obj,
        is_enabled=reminder.is_enabled
    )
    
    db.add(db_reminder)
    db.commit()
    db.refresh(db_reminder)
    
    # Convert Time object to string for serialization
    reminder_dict = {
        "id": db_reminder.id,
        "user_id": db_reminder.user_id,
        "time": db_reminder.time.strftime("%H:%M"),
        "is_enabled": db_reminder.is_enabled,
        "created_at": db_reminder.created_at,
        "updated_at": db_reminder.updated_at
    }
    return schemas.ReminderOut(**reminder_dict)

@router.put("/{reminder_id}", response_model=schemas.ReminderOut)
def update_reminder(
    reminder_id: int,
    reminder_update: schemas.ReminderUpdate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id)
):
    """Update a reminder (full update)"""
    reminder = (
        db.query(models.Reminder)
        .filter(models.Reminder.id == reminder_id, models.Reminder.user_id == user_id)
        .first()
    )
    
    if not reminder:
        raise HTTPException(status_code=404, detail="Reminder not found")
    
    # Update fields
    if reminder_update.time is not None:
        time_parts = reminder_update.time.split(':')
        reminder.time = dt_time(int(time_parts[0]), int(time_parts[1]))
    
    if reminder_update.is_enabled is not None:
        reminder.is_enabled = reminder_update.is_enabled
    
    db.commit()
    db.refresh(reminder)
    
    # Convert Time object to string for serialization
    reminder_dict = {
        "id": reminder.id,
        "user_id": reminder.user_id,
        "time": reminder.time.strftime("%H:%M"),
        "is_enabled": reminder.is_enabled,
        "created_at": reminder.created_at,
        "updated_at": reminder.updated_at
    }
    return schemas.ReminderOut(**reminder_dict)

@router.patch("/{reminder_id}", response_model=schemas.ReminderOut)
def patch_reminder(
    reminder_id: int,
    reminder_update: schemas.ReminderUpdate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id)
):
    """Partially update a reminder"""
    reminder = (
        db.query(models.Reminder)
        .filter(models.Reminder.id == reminder_id, models.Reminder.user_id == user_id)
        .first()
    )
    
    if not reminder:
        raise HTTPException(status_code=404, detail="Reminder not found")
    
    # Update only provided fields
    if reminder_update.time is not None:
        time_parts = reminder_update.time.split(':')
        reminder.time = dt_time(int(time_parts[0]), int(time_parts[1]))
    
    if reminder_update.is_enabled is not None:
        reminder.is_enabled = reminder_update.is_enabled
    
    db.commit()
    db.refresh(reminder)
    
    # Convert Time object to string for serialization
    reminder_dict = {
        "id": reminder.id,
        "user_id": reminder.user_id,
        "time": reminder.time.strftime("%H:%M"),
        "is_enabled": reminder.is_enabled,
        "created_at": reminder.created_at,
        "updated_at": reminder.updated_at
    }
    return schemas.ReminderOut(**reminder_dict)

@router.delete("/{reminder_id}")
def delete_reminder(
    reminder_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id)
):
    """Delete a reminder"""
    reminder = (
        db.query(models.Reminder)
        .filter(models.Reminder.id == reminder_id, models.Reminder.user_id == user_id)
        .first()
    )
    
    if not reminder:
        raise HTTPException(status_code=404, detail="Reminder not found")
    
    db.delete(reminder)
    db.commit()
    return {"message": "Reminder deleted successfully"}
