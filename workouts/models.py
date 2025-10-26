from sqlalchemy import Column, Integer, String, text, TIMESTAMP, ForeignKey, JSON, ARRAY, Boolean
from db.session import Base


class Workout(Base):
    __tablename__ = "workouts"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    started_at = Column(TIMESTAMP, server_default=text("now()"))
    ended_at = Column(TIMESTAMP, nullable=True)
    title = Column(String(255))
    # Align with migrations: workout_types TEXT[]
    workout_types = Column(ARRAY(String), nullable=True)
    notes = Column(String, nullable=True)
    # JSONB in DB; SQLAlchemy JSON maps fine for Postgres JSONB
    exercises = Column(JSON, nullable=True)
    # Draft flag
    is_draft = Column(Boolean, default=False, server_default=text("false"))
    # Soft delete column
    deleted_at = Column(TIMESTAMP, nullable=True)
