from pydantic import BaseModel
from typing import Optional

class MetricBase(BaseModel):
    name:str 
    description: Optional[str] = None
    data_type: str


class MetricCreate(MetricBase):
    pass


class MetricUpdate(MetricBase):
    name: Optional[str] = None
    active: Optional[bool] = None


class MetricOut(MetricBase):
    id: int
    active: bool

    class Config:
        orm_mode = True