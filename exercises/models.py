from db.session import Base
from sqlalchemy import Column, Integer, String, Text, ForeignKey
from sqlalchemy.dialects.postgresql import ARRAY

class Exercise(Base):
    __tablename__ = "exercise"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False, unique=True)
    description = Column(Text)
    exercise_type = Column(String(255))
    exercise_subtype = Column(String(255))
    primary_muscles = Column(ARRAY(Text), nullable=False)
    secondary_muscles = Column(ARRAY(Text))
    equipment = Column(String(255))
    equipment_modifiers = Column(ARRAY(Text))
    tags = Column(ARRAY(Text))
    injury_pain = Column(Text)