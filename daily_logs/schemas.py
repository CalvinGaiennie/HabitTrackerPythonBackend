from pydantic import BaseModel
from typing import Optional

class DailyLogBase(BaseModel):
    
class DailyLogCreate(DailyLogBase):

class DailyLogUpdate(DailyLogBase):

class DailyLogOut(DailyLogBase):

    class Config:
        orm_mode = True

