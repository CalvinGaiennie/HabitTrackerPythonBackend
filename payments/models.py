from sqlalchemy import Column, Integer, String, Boolean, TIMESTAMP, text
from db.session import Base


class StripeCustomer(Base):
    __tablename__ = "stripe_customers"

    id = Column(Integer, primary_key=True, index=True)
    stripe_customer_id = Column(String(255), unique=True, nullable=False)
    tier = Column(String(20))
    active = Column(Boolean, default=False)
    subscription_id = Column(String(255))
    created_at = Column(TIMESTAMP, server_default=text("now()"))



