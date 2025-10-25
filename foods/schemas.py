from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

class FoodBase(BaseModel):
    id: int
    name: str
    serving_size_ammount: int
    serving_size_unit: str
    serving_unit: str
    calories: int
    protein_g: int
    carbs_g: int
    fat_g: int
    notes: str


class FoodCreate(FoodBase):
    created_at: datetime

class FoodOut(FoodBase):
    pass