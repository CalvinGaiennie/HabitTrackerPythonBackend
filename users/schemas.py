from pydantic import BaseModel, ConfigDict
from typing import Optional, Dict
from datetime import datetime

class HomePageSection(BaseModel):
    section: str
    metricIds: list[int]

class UserSettings(BaseModel):
    enabledPages: Optional[list[str]] = None
    homePageLayout: Optional[list[HomePageSection]] = None
    workoutTypes: Optional[list[str]] = None

class UserCreate(BaseModel):
    username: str
    email: str
    password: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    settings: Optional[dict] = {}

class UserBase(BaseModel):
    id: int
    settings: dict
    username: str
    email: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    last_login: Optional[datetime] = None
    is_verified: Optional[bool] = False
    class Config:
        from_attributes = True