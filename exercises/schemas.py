from pydantic import BaseModel
from typing import Optional

class Exercise(Base):
    __tablename__ = "exercises"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False)
    description = Column(Text)
    exercise_type = Column(String(255))
    exercise_subtype = Column(String(255))
    primary_muscles = Column(Text, nullable=False)
    secondary_muscles = Column(Text)
    equipment = Column(String)
    tags = Column(Text)
    injury_pain = Column(Text)

class ExerciseBase(BaseModel):
    

class ExerciseCreate():

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