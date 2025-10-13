from pydantic import BaseModel
from typing import Optional

class Exercise(Base):
    __tablename__ = "exercises"


class ExerciseBase(BaseModel):

class ExerciseCreate():
    user_id: int
    name: str
    description: Optional[str] = None
    exercise_type: Optional[str] = None
    exercise_subtype: Optional[str] = None
    primary_muscles: str
    secondary_muscles: Optional[str] = None
    tags: str

class ExerciseUpdate():

class ExerciseOut():

class ExerciseFullForExampleWhenWritingSchemas():
    id: int
    user_id: int
    name: str
    description: Optional[str] = None
    exercise_type: Optional[str] = None
    exercise_subtype: Optional[str] = None
    primary_muscles: str
    secondary_muscles: Optional[str] = None
    equipment: str
    tags: str
    injury_pain: str