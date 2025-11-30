from pydantic import BaseModel
from datetime import date
from typing import Optional
from decimal import Decimal


class FoodEntryCreate(BaseModel):
    user_id: int
    food_id: Optional[int] = None
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