from sqlalchemy import Column, Integer, String, Boolean, TIMESTAMP, text
from sqlalchemy.dialects.postgresql import JSONB
from db.session import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    first_name = Column(String(100))
    last_name = Column(String(100))
    created_at = Column(TIMESTAMP, server_default=text("now()"))
    updated_at = Column(TIMESTAMP, server_default=text("now()"))
    last_login = Column(TIMESTAMP)
    is_verified = Column(Boolean, default=False)
    settings = Column(JSONB, default={})
