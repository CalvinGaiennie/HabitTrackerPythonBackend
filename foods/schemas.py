from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional, Literal


class FoodCreate(BaseModel):
    name: str
    category: Optional[str] = None
    brand: Optional[str] = None
    serving_size_amount: float = Field(default=100, gt=0)
    serving_size_unit: Literal["g", "ml", "piece", "cup", "tbsp", "tsp"] = "g"
    serving_unit: Optional[str] = None
    calories: Optional[float] = Field(default=None, ge=0)
    protein_g: Optional[float] = Field(default=None, ge=0)
    carbs_g: Optional[float] = Field(default=None, ge=0)
    fat_g: Optional[float] = Field(default=None, ge=0)
    fiber_g: Optional[float] = Field(default=None, ge=0)
    notes: Optional[str] = None


class FoodUpdate(BaseModel):
    name: Optional[str] = None
    category: Optional[str] = None
    brand: Optional[str] = None
    serving_size_amount: Optional[float] = Field(default=None, gt=0)
    serving_size_unit: Optional[Literal["g", "ml", "piece", "cup", "tbsp", "tsp"]] = None
    serving_unit: Optional[str] = None
    calories: Optional[float] = Field(default=None, ge=0)
    protein_g: Optional[float] = Field(default=None, ge=0)
    carbs_g: Optional[float] = Field(default=None, ge=0)
    fat_g: Optional[float] = Field(default=None, ge=0)
    fiber_g: Optional[float] = Field(default=None, ge=0)
    notes: Optional[str] = None


class FoodOut(FoodCreate):
    id: int
    user_id: Optional[int] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True