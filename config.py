from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field

class Settings(BaseSettings):
    APP_ENV:  str = Field(default="development")
    API_ORIGINS: str = Field(default="http://localhost:5173")
    DATABASE_URL: str = Field(default="postgresql://postgres:postgres@localhost:5432/habit_tracker")
    JWT_SECRET_KEY: str = Field(default="your-secret-key-change-this-in-production-use-env-file")

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

settings = Settings()