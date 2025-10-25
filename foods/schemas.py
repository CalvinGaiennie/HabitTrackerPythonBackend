from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

class FoodBase(BaseModel):
    id: int
    name: str
    serving_size_ammount: int
    serving_size_unit: int
    serving_unit: int
    calories: 
    protein_g: int
    carbs_g: int
    fat_g: int
    notes: str


class FoodCreate(FoodBase):
    created_at: datetime

class FoodOut(FoodBase):
    pass


class ExerciseBase(BaseModel):
    user_id: int
    name: str
    description: Optional[str] = None
    exercise_type: Optional[str] = None
    exercise_subtype: Optional[str] = None
    primary_muscles: List[str]
    secondary_muscles: Optional[List[str]] = None
    tags: Optional[List[str]] = None