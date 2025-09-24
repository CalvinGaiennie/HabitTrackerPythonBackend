from sqlalchemy import Column, Integer, String, text, TIMESTAMP, ForeignKey
from db.session import Base


class WorkoutBase(Base):
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Interger, ForeignKey("users.id", ondelete="CASCADE"))
    started_at = Column(TIMESTAMP, server_default=text("now()"))
    ended_at= Column(TIMESTAMP, server_default=text("now()"))
    tile=Column(String(255))
    workout_type=Column(String(255))
    notes=Column(String)
