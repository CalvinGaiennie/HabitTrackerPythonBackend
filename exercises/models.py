from db.session import Base
from sqlalchemy import Column, Integer, String, Text, ForeignKey

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