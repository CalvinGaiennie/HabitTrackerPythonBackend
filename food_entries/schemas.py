from pydantic import BaseModel
from datetime import date, datetime
from typing import Optional
from decimal import Decimal


class FoodEntryCreate(BaseModel):
    food_id: Optional[int] = None
    food_name: str
    log_date: date
    quantity: Decimal = Decimal("1")
    calories: Optional[Decimal] = None
    protein_g: Optional[Decimal] = None
    carbs_g: Optional[Decimal] = None
    fat_g: Optional[Decimal] = None
    meal_type: Optional[str] = None
    notes: Optional[str] = None


class FoodEntryOut(FoodEntryCreate):
    id: int
    user_id: int
    created_at: datetime