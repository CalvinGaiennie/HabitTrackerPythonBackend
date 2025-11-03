from db.session import Base
from sqlalchemy import Column, Integer, String, Text, ForeignKey, Numeric, TIMESTAMP, text

class Food(Base):
    __tablename__ = "foods"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False, unique=True)
    category = Column(String(255))
    brand = Column(String(255))
    serving_size_amount = Column(Numeric(precision=8, scale=2), nullable=False, default=100)
    serving_size_unit = Column(String(255), nullable=False)
    serving_unit = Column(String(255))
    calories = Column(Numeric(precision=8, scale=2))
    protein_g = Column(Numeric(precision=8, scale=2))
    carbs_g = Column(Numeric(precision=8, scale=2))
    fat_g = Column(Numeric(precision=8, scale=2))
    fiber_g = Column(Numeric(precision=8, scale=2))
    notes = Column(Text)
    created_at = Column(TIMESTAMP, server_default=text("now()"))