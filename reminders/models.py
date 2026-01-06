from sqlalchemy import Column, Integer, Boolean, Time, TIMESTAMP, ForeignKey, text
from db.session import Base

class Reminder(Base):
    __tablename__ = "reminders"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    time = Column(Time, nullable=False)  # Format: HH:MM:SS
    is_enabled = Column(Boolean, nullable=False, default=True, index=True)
    created_at = Column(TIMESTAMP, server_default=text("now()"))
    updated_at = Column(TIMESTAMP, server_default=text("now()"))
