from pydantic import BaseModel, Field, field_validator
from typing import Optional
from datetime import datetime

class ReminderBase(BaseModel):
    time: str = Field(..., description="Time in HH:MM format (e.g., '09:00', '19:30')")
    is_enabled: bool = Field(default=True, description="Whether the reminder is enabled")

    @field_validator('time')
    @classmethod
    def validate_time_format(cls, v: str) -> str:
        """Validate time is in HH:MM format"""
        try:
            parts = v.split(':')
            if len(parts) != 2:
                raise ValueError("Time must be in HH:MM format")
            hour = int(parts[0])
            minute = int(parts[1])
            if not (0 <= hour <= 23) or not (0 <= minute <= 59):
                raise ValueError("Hour must be 0-23, minute must be 0-59")
            # Normalize to HH:MM format
            return f"{hour:02d}:{minute:02d}"
        except ValueError as e:
            raise ValueError(f"Invalid time format: {e}")

class ReminderCreate(ReminderBase):
    user_id: int

class ReminderUpdate(BaseModel):
    time: Optional[str] = Field(None, description="Time in HH:MM format")
    is_enabled: Optional[bool] = None

    @field_validator('time')
    @classmethod
    def validate_time_format(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        try:
            parts = v.split(':')
            if len(parts) != 2:
                raise ValueError("Time must be in HH:MM format")
            hour = int(parts[0])
            minute = int(parts[1])
            if not (0 <= hour <= 23) or not (0 <= minute <= 59):
                raise ValueError("Hour must be 0-23, minute must be 0-59")
            return f"{hour:02d}:{minute:02d}"
        except ValueError as e:
            raise ValueError(f"Invalid time format: {e}")

class ReminderOut(ReminderBase):
    id: int
    user_id: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    model_config = {"from_attributes": True}
