from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from db.session import SessionLocal
from . import models, schemas
from datetime import date, datetime, timedelta
from typing import Optional
import json
from .utils.clock import parse_clock_data

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
        for field, value in log.model_dump(exclude_unset=True).items():
            setattr(db_log, field, value)

    else: 
        db_log = models.DailyLog(**log.model_dump())
        db.add(db_log)

    db.commit()
    db.refresh(db_log)
    return db_log


@router.get("/", response_model=list[schemas.DailyLogOut])
def get_daily_logs(start_date: Optional[date] = None, end_date: Optional[date] = None, log_date: Optional[date] = None, user_id: str = None, db: Session = Depends(get_db)):
    query = db.query(models.DailyLog).filter(models.DailyLog.deleted_at.is_(None))  # Filter out soft-deleted logs
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

@router.post("/clock-in")
def clock_in(metric_id: int, db: Session = Depends(get_db)):
    today = date.today()
    now = datetime.now()
    
    # Get or create today's log entry
    db_log = (
        db.query(models.DailyLog)
        .filter(models.DailyLog.metric_id == metric_id)
        .filter(models.DailyLog.log_date == today)
        .first()
    )
    
    if not db_log:
        # Create new log entry
        db_log = models.DailyLog(
            user_id=1,  # TODO: Get from auth
            metric_id=metric_id,
            log_date=today,
            value_text=json.dumps({
                "current_state": "clocked_in",
                "sessions": [],
                "total_duration_minutes": 0,
                "last_updated": now.isoformat()
            })
        )
        db.add(db_log)
    else:
        # Update existing log
        clock_data = json.loads(db_log.value_text or "{}")
        if clock_data.get("current_state") == "clocked_in":
            raise HTTPException(status_code=400, detail="Already clocked in")
        
        clock_data["current_state"] = "clocked_in"
        clock_data["last_updated"] = now.isoformat()
        db_log.value_text = json.dumps(clock_data)
    
    db.commit()
    db.refresh(db_log)
    return json.loads(db_log.value_text)

@router.post("/clock-out")
def clock_out(metric_id: int, db: Session = Depends(get_db)):
    today = date.today()
    now = datetime.now()
    
    # Get today's log entry
    db_log = (
        db.query(models.DailyLog)
        .filter(models.DailyLog.metric_id == metric_id)
        .filter(models.DailyLog.log_date == today)
        .first()
    )
    
    if not db_log:
        raise HTTPException(status_code=404, detail="No clock in found for today")
    
    clock_data = json.loads(db_log.value_text or "{}")
    if clock_data.get("current_state") != "clocked_in":
        raise HTTPException(status_code=400, detail="Not currently clocked in")
    
    # Calculate session duration
    last_clock_in = datetime.fromisoformat(clock_data["last_updated"])
    session_duration = int((now - last_clock_in).total_seconds() / 60)
    
    # Add completed session
    sessions = clock_data.get("sessions", [])
    sessions.append({
        "clock_in": last_clock_in.isoformat(),
        "clock_out": now.isoformat(),
        "duration_minutes": session_duration
    })
    
    # Update clock data
    clock_data["current_state"] = "clocked_out"
    clock_data["sessions"] = sessions
    clock_data["total_duration_minutes"] = sum(s["duration_minutes"] for s in sessions)
    clock_data["last_updated"] = now.isoformat()
    
    db_log.value_text = json.dumps(clock_data)
    db.commit()
    db.refresh(db_log)
    return clock_data

@router.get("/clock-status/{metric_id}")
def get_clock_status(metric_id: int, date: Optional[str] = None, db: Session = Depends(get_db)):
    from datetime import date as date_class
    target_date_str = date or date_class.today().isoformat()
    target_date = date_class.fromisoformat(target_date_str)
    
    db_log = (
        db.query(models.DailyLog)
        .filter(models.DailyLog.metric_id == metric_id)
        .filter(models.DailyLog.log_date == target_date)
        .first()
    )
    
    if not db_log or not db_log.value_text:
        return None
    
    return json.loads(db_log.value_text)

@router.get("/clock-status-for-week/{metric_id}")
def get_clock_status_for_week(metric_id: int, *, end_date: Optional[str] = Query( None, description="=ISO date (YYYY-MM-DD) - defaults to today"), db: Session = Depends(get_db),):
    today = date.today()
    ref_date = today
    if end_date:
        try:
            ref_date = date.fromisoformat(end_date)
        except ValueError:
            raise HTTPException(
                status_code=400,
                detail="Invalid end_date - must be YYYY-MM-DD"
            )
    monday = ref_date - timedelta(days=ref_date.isoweekday() - 1)
    week_days = [monday + timedelta(days=i) for i in range(7)]
    
    rows = (db.query(models.DailyLog)
        .filter(models.DailyLog.metric_id == metric_id)
        .filter(models.DailyLog.log_date >= week_days[0])
        .filter(models.DailyLog.log_date <= week_days[6])
        .all()
    )

    day_map: dict[str, int] = {}
    weekly_total = 0

    for row in rows:
        clock_data = parse_clock_data(row.value_text)
        minutes = clock_data.get("total_duration_minutes", 0)
        iso = row.log_date.isoformat()
        day_map[iso] = minutes
        weekly_total += minutes
    
    days_out: List[dict] = []
    for d in week_days:
        iso= d.isoformat()
        days_out.append({"date": iso, "minutes": day_map.get(iso, 0)})

    return {
        "week_start": monday.isoformat(),
        "week_end": (monday + timedelta(days=6)).isoformat(),
        "weekly_total_minutes": weekly_total,
        "days": days_out,
    }


@router.put("/{log_id}", response_model=schemas.DailyLogOut)
def update_daily_log(log_id: int, log_update: schemas.DailyLogUpdate, db: Session = Depends(get_db)):
    db_log = db.query(models.DailyLog).filter(
        models.DailyLog.id == log_id,
    ).first()
    
    if not db_log:
        raise HTTPException(status_code=404, detail="Daily log not found")
    
    for field, value in log_update.model_dump(exclude_unset=True).items():
        setattr(db_log, field, value)
    
    db.commit()
    db.refresh(db_log)
    return db_log

@router.delete("/{log_id}")
def delete_daily_log(log_id: int, db: Session = Depends(get_db)):
    db_log = db.query(models.DailyLog).filter(
        models.DailyLog.id == log_id,
    ).first()
    
    if not db_log:
        raise HTTPException(status_code=404, detail="Daily log not found")
    
    # Soft delete: set deleted_at timestamp
    from datetime import datetime
    db_log.deleted_at = datetime.utcnow()
    db.commit()
    return {"message": "Daily log deleted successfully"}
