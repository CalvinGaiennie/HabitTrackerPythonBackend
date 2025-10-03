from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime


class ExerciseSet(BaseModel):
    reps: Optional[int] = None
    weight: Optional[float] = None
    rest_duration: Optional[int] = None  # in seconds
    notes: Optional[str] = None


class Exercise(BaseModel):
    name: str
    sets: List[ExerciseSet]
    notes: Optional[str] = None


class WorkoutBase(BaseModel):
    title: str
    workout_types: List[str]
    notes: Optional[str] = None
    exercises: Optional[List[Exercise]] = None


class WorkoutCreate(WorkoutBase):
    pass


class WorkoutUpdate(BaseModel):
    title: Optional[str] = None
    workout_types: Optional[List[str]] = None
    notes: Optional[str] = None
    exercises: Optional[List[Exercise]] = None
    ended_at: Optional[datetime] = None


class WorkoutOut(WorkoutBase):
    id: int
    user_id: int
    started_at: datetime
    ended_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True