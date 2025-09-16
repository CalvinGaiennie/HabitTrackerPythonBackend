from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field
import allow_origins
class Settings(BaseSettings):
    APP_ENV:  str = Field(default="development")
    API_ORIGINS: str = Field(default="http://localhost:5173")
    DATABASE_URL: str = Field(default="postgresql://postgres:postgres@localhost:5432/habit_tracker")

    model_config = SettingsConfigDict(
        env_file=.env
        env_file_encoding="utf-8",
        extra="ignore",
    )

    settings = Settings()