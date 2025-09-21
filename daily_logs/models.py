from sqlalchemy import Column, Integer, String, Date, ForeignKey, Boolean, TIMESTAMP, Text, Numeric, text
from db.session import Base

class Daily_Logs(Base):
    __tablename__ = "daily_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    metric_id = Column(Integer, ForeignKey("metrics.id", ondelete="CASCADE"), nullable=False)
    log_date = Column(Date, nullable=False)
    value_int = Column(Integer)
    value_boolean = Column(Boolean)
    value_text = Column(Text)
    value_decimal = Column(Numeric(10, 2))
    note = Column(Text)
    created_at = Column(TIMESTAMP, server_default=text("now()"))
