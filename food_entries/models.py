from db.session import Base
from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    ForeignKey,
    Numeric,
    Date,
    TIMESTAMP,
    text,
)


class FoodEntry(Base):
    __tablename__ = "food_entry"  # matches DBSchema.sql

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    # Allow SET NULL on food deletion to preserve log history
    food_id = Column(Integer, ForeignKey("foods.id", ondelete="SET NULL"), nullable=True)
    food_name = Column(Text, nullable=False)
    log_date = Column(Date, nullable=False)
    quantity = Column(Numeric(precision=6, scale=2), nullable=False, default=1)
    calories = Column(Numeric(precision=8, scale=2), nullable=True)
    protein_g = Column(Numeric(precision=8, scale=2), nullable=True)
    carbs_g = Column(Numeric(precision=8, scale=2), nullable=True)
    fat_g = Column(Numeric(precision=8, scale=2), nullable=True)
    meal_type = Column(String(255), nullable=False, server_default="snack")
    notes = Column(Text, nullable=True)
    created_at = Column(TIMESTAMP, server_default=text("now()"))
    updated_at = Column(TIMESTAMP, server_default=text("now()"))