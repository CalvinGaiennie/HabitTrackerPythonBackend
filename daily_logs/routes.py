from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.session import SessionLocal
from . import models, schemas

router = APIRouter(prefix="/daily_logs", tags=["daily_logs"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.DailyLogOut)
def create_daily_log(daily_log: schemas.DailyLogCreate, db: Session = Depends(get_db)): 
    db_daily_log = models.Daily_Logs(**daily_log.model_dump(), user_id=1)
    db.add(db_daily_log)
    db.commit()
    db.refresh(db_daily_log)
    return db_daily_log

@router.get("/", response_model=list[schemas.DailyLogOut])
def get_daily_logs(db: Session = Depends(get_db)):
    return db.query(models.Daily_Logs).all()

@router.delete("/{daily_log_id}")
def deactivate_daily_log(daily_log_id: int, db: Session = Depends(get_db)):
    daily_log = db.query(models.Daily_Logs).get(daily_log_id)
    if not daily_log:
        raise HTTPException(status_code=404, detail="Daily Log not found")
    # Note: The model doesn't have an 'active' field, so we'll just delete it
    db.delete(daily_log)
    db.commit()
    return { "message": "Daily Log deleted"}