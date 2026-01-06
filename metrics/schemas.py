from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class MetricMini(BaseModel):
    id: int
    name: str
    initials: Optional[str] = None
    data_type: str
    unit: Optional[str] = None
    time_type: str

    model_config = {"from_attributes": True}

class MetricBase(BaseModel):
    category: Optional[str] = None
    subcategory: Optional[str] = None
    name: str
    description: Optional[str] = None
    initials: Optional[str] = None
    parent_id: Optional[int] = None
    is_required: bool = False
    data_type: str
    unit: Optional[str] = None
    scale_min: Optional[int] = None
    scale_max: Optional[int] = None
    modifier_label: Optional[str] = None
    modifier_value: Optional[str] = None
    notes_on: bool = False
    active: bool = True
    time_type: str

    model_config = {"from_attributes": True}

class MetricCreate(MetricBase):
    pass

class MetricUpdate(BaseModel):
    category: Optional[str] = None
    subcategory: Optional[str] = None
    name: Optional[str] = None
    description: Optional[str] = None
    initials: Optional[str] = None
    parent_id: Optional[int] = None
    is_required: Optional[bool] = None
    data_type: Optional[str] = None
    unit: Optional[str] = None
    scale_min: Optional[int] = None
    scale_max: Optional[int] = None
    modifier_label: Optional[str] = None
    modifier_value: Optional[str] = None
    notes_on: Optional[bool] = None
    active: Optional[bool] = None

    model_config = {"from_attributes": True}

class MetricOut(MetricBase):
    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime
