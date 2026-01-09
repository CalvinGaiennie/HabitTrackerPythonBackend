from pydantic import BaseModel, ConfigDict
from typing import Optional, Dict, Literal, Any
from datetime import datetime

class HomePageSection(BaseModel):
    section: str
    metricIds: list[int]

class ChartDefinition(BaseModel):
    type: Literal["line", "bar", "pie", "bubble", ""]
    metricId: int

class UserSettings(BaseModel):
    enabledPages: Optional[list[str]] = None
    homePageLayout: Optional[list[HomePageSection]] = None
    workoutTypes: Optional[list[str]] = None
    # Optional analytics configuration for home page charts
    homePageAnalytics: Optional[list[ChartDefinition]] = None

class UserCreate(BaseModel):
    username: str
    email: str
    password: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    settings: Optional[dict] = {}

class UserLogin(BaseModel):
    email: str
    password: str

class PasswordChange(BaseModel):
    old_password: str
    new_password: str

class PasswordResetRequest(BaseModel):
    email: str

class PasswordReset(BaseModel):
    token: str
    new_password: str

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

class UserResponse(BaseModel):
    user: UserBase
    access_token: str

class UserWithTier(UserBase):
    tier: str  # "free" | "monthly" | "annual"

class UserWithSettings(UserBase):
    # Return strongly-typed settings where possible; allow additional keys
    settings: dict
    tier: str  # "free" | "monthly" | "annual"