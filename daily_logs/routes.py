from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import joinedload, Session
from db.session import SessionLocal
from . import models, schemas
from datetime import date
from typing import Optional

router = APIRouter(prefix="/daily_logs", tags=["daily_logs"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.DailyLogOut)
def create_or_update_log(log: schemas.DailyLogCreate, db: Session = Depends(get_db)):
    db_log = (
        db.query(models.DailyLog)
        .filter(models.DailyLog.metric_id == log.metric_id)
        .filter(models.DailyLog.log_date == log.log_date)
        .first()
    )

    if db_log:
        for field, value in log.dict(exclude_unset=True).items():
            setattr(db_log, field, value)

    else: 
        db_log = models.DailyLog(**log.dict())
        db.add(db_log)

    db.commit()
    db.refresh(db_log)
    return db_log


@router.get("/", response_model=list[schemas.DailyLogOut])
def get_daily_logs(start_date: Optional[date] = None, end_date: Optional[date] = None, log_date: Optional[date] = None, user_id: str = None, db: Session = Depends(get_db)):
    query = db.query(models.DailyLog).options(joinedload(models.DailyLog.metric))
    if log_date:
        query = query.filter(models.DailyLog.log_date == log_date)
    else:
        if start_date:
            query = query.filter(models.DailyLog.log_date >= start_date)
        if end_date:
            query = query.filter(models.DailyLog.log_date <= end_date)
    if user_id:
        query = query.filter(models.DailyLog.user_id == user_id)  # Add user_id filter
    return query.order_by(models.DailyLog.log_date.desc()).all()
