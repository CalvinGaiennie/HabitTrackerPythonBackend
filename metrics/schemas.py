from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

class MetricBase(BaseModel):
    name: str 
    description: Optional[str] = None
    data_type: str
    category: Optional[str] = None
    subcategory: Optional[str] = None
    unit: Optional[str] = None
    scale_min: Optional[int] = None
    scale_max: Optional[int] = None
    modifier_label: Optional[str] = None
    modifier_value: Optional[str] = None
    notes_on: Optional[bool] = False
    is_required: Optional[bool] = False


class MetricCreate(MetricBase):
    pass


class MetricUpdate(MetricBase):
    name: Optional[str] = None
    active: Optional[bool] = None


class MetricOut(MetricBase):
    id: int
    user_id: int
    parent_id: Optional[int] = None
    active: bool
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)