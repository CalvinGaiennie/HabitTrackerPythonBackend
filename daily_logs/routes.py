from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.session import SessionLocal
from . import models, schemas
from datetime import date

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
        db.query(models.Daily_Logs)
        .filter(models.Daily_Logs.metric_id == log.metric_id)
        .filter(models.Daily_Logs.log_date == log.log_date)
        .first()
    )

    if db_log:
        for field, value in log.dict(exclude_unset=True).items():
            setattr(db_log, field, value)

    else: 
        db_log = models.Daily_Logs(**log.dict())
        db.add(db_log)

    db.commit()
    db.refresh(db_log)
    return db_log

@router.get("/")
def get_daily_logs(log_date: date, db: Session = Depends(get_db)):
    return (
        db.query(models.Daily_Logs)
        .filter(models.Daily_Logs.log_date == log_date)
        .all()
    )