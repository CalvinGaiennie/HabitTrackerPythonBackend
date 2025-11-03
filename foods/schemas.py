from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class FoodCreate(BaseModel):
    name: str
    category: Optional[str] = None
    brand: Optional[str] = None
    serving_size_amount: Optional[float] = 100
    serving_size_unit: Optional[str] = "g"
    serving_unit: Optional[str] = None
    calories: Optional[float] = None
    protein_g: Optional[float] = None
    carbs_g: Optional[float] = None
    fat_g: Optional[float] = None
    fiber_g: Optional[float] = None
    notes: Optional[str] = None


class FoodOut(FoodCreate):
    id: int
    user_id: Optional[int] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True