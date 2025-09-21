from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, TIMESTAMP, text, Text, Numeric
from db.session import Base

class Metric(Base):
    __tablename__ = "metrics"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    category = Column(String(255))
    subcategory = Column(String(255))
    name = Column(String(255), nullable=False)
    description = Column(Text)
    parent_id = Column(Integer, ForeignKey("metrics.id", ondelete="SET NULL"))
    is_required = Column(Boolean, default=False)
    data_type = Column(String(255), nullable=False)  # int, boolean, text, scale, decimal
    unit = Column(String(255))
    scale_min = Column(Integer)  # only applies if data_type = 'scale'
    scale_max = Column(Integer)  # only applies if data_type = 'scale'
    modifier_label = Column(String(255))
    modifier_value = Column(String(255))
    notes_on = Column(Boolean, default=False)
    active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=text("now()"))
    updated_at = Column(TIMESTAMP, server_default=text("now()"))
