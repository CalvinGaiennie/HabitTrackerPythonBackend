from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, TIMESTAMP, text, Numeric
from app.db.session import Base

class Daily_Logs(Base):
    __tablename__ = "daily_logs"

    id = Column(Integer, primary_key=True, index=True),
    user_id = Column(Integer, ForeignKey("users.id", ondelete = "CASCADE")),
    metric_id = Column(Integer, nullable=False, ForeignKey("metrics.id"), ondelete = "CASCADE"),
    log_date = Column(Date, nullable=False),
    value_int = Column(Integer),
    value_boolean = Column(Boolean),
    value_text = Column(TEXT),
    value_decimal = Column(Numeric(10,2)),
    note = Column(Text),
    created_at = Column(TIMESTAMP, server_default=text("now()"))
