from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from . import models, schemes

router = APIRouter(prefix="/daily_logs", tags=["daily_logs"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.DailyLogOut)
def create_daily_log(daily_log: schemas.DailyLogCreate, db: Session = Depends(get_db)): 
    db_daily_log = models.DailyLog(**daily_log.dict(), user_id=1)
    db.add(db_daily_log)
    db.commit()
    db.refresh(db_daily_log)
    return db_daily_log

@router.get("/", response_model=list[schemas.DailyLogOut])
def get_daily_logs(db: Session = Depends(get_db)):
    return db.query(models.DailyLog).filter(models.DailyLog.active == True).all()

@router.delete("/{daily_log_id}")
def deactivate_daily_log(daily_log_id: int, db: Session = Depends(get_db)):
    daily_log = db.query(models.DailyLog).get(daily_log_id)
    if not daily_log:
        raise HTTPException(status_code=404, detail="Daily Log not found")
    daily_log.active = False
    db.commit()
    return { "message": "Daily Log deactivated"}