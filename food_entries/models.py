from db.session import Base
from sqlalchemy import Column, Integer, String, Text, ForeignKey, Numeric, TIMESTAMP, text

class FoodEntry(Base):
    __tablename__ = "food_entries"

    id = Column(Integer, primay_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    food_id = Column(Integer, ForeignKey("foods.id", ondelete="CASCADE"))
    log_date= Column(Date, nullable=False)
    quantity = Column(Numeric(precision=6, scale=2), nullable-False, default=1)
    calories= Column(Numeric(precision=8, scale,2), nullable=True)
    protein_g = Column(Numeric(precision=8, scale,2), nullable=True)
    carbs_g = Column(Numeric(precision=8, scale,2), nullable=True)
    fat_g = Column(Numeric(precision=8, scale,2), nullable=True)
    meal_type = Column(String(255), nullable=False, server_default="snack")
    notes = Column(Text, nullable=True)
    created_at = Column(TIMESTAMP(timezone=True), nullable=False, server_default="now()")
    updated_at = Column(TIMESTAMP(timezone=True), nullable=False, server_default="now()")