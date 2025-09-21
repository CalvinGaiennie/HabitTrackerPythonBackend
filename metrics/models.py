from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, TIMESTAMP, text
from app.db.session import Base

class Metric(Base):
    __tablename__ = "metrics"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False)
    description = Column(String, nullable=True)
    data_type = Column(String(50), nullable=False)  # int, boolean, text, scale
    active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=text("now()"))
    updated_at = Column(TIMESTAMP, server_default=text("now()"))
