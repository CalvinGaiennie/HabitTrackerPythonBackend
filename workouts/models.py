from sqlalchemy import Column, Integer, String, text, TIMESTAMP, ForeignKey, JSON, ARRAY
from db.session import Base


class Workout(Base):
    __tablename__ = "workout"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    started_at = Column(TIMESTAMP, server_default=text("now()"))
    ended_at = Column(TIMESTAMP, nullable=True)
    title = Column(String(255))
    workout_type = Column(ARRAY(String), nullable=True)  # Array of workout types
    notes = Column(String, nullable=True)
