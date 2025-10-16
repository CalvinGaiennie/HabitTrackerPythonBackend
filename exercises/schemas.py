from pydantic import BaseModel
from typing import Optional, List

class ExerciseBase(BaseModel):
    user_id: int
    name: str
    description: Optional[str] = None
    exercise_type: Optional[str] = None
    exercise_subtype: Optional[str] = None
    primary_muscles: List[str]
    secondary_muscles: Optional[List[str]] = None
    tags: Optional[List[str]] = None

class ExerciseCreate(ExerciseBase):
    equipment: Optional[str] = None
    equipment_modifiers: Optional[List[str]] = None
    injury_pain: Optional[str] = None

class ExerciseUpdate(BaseModel):
    user_id: Optional[int] = None
    name: Optional[str] = None
    description: Optional[str] = None
    exercise_type: Optional[str] = None
    exercise_subtype: Optional[str] = None
    primary_muscles: Optional[List[str]] = None
    secondary_muscles: Optional[List[str]] = None
    tags: Optional[List[str]] = None
    equipment: Optional[str] = None
    equipment_modifiers: Optional[List[str]] = None
    injury_pain: Optional[str] = None

class ExerciseOut(ExerciseBase):
    id: int
    equipment: Optional[str] = None
    equipment_modifiers: Optional[List[str]] = None
    injury_pain: Optional[str] = None

    model_config = {"from_attributes": True}

class ExerciseFullExample(ExerciseOut):
    pass