from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import date
from decimal import Decimal
from datetime import datetime
from metrics.schemas import MetricMini

class DailyLogBase(BaseModel):
    metric_id: int
    log_date: date
    value_int: Optional[int] = None
    value_boolean: Optional[bool] = None
    value_text: Optional[str] = None
    value_decimal: Optional[Decimal] = None
    note: Optional[str] = None

class DailyLogCreate(DailyLogBase):
    user_id: int

class DailyLogUpdate(DailyLogBase):
    pass

class DailyLogOut(DailyLogBase):
    id: int
    user_id: int
    created_at: datetime
    metric: MetricMini

    model_config = ConfigDict(from_attributes=True)