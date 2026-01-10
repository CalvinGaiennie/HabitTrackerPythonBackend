from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from db.session import SessionLocal
from . import models, schemas
from datetime import date, datetime, timedelta
from typing import Optional, List
import json
from .utils.clock import parse_clock_data
from core.auth import get_current_user_id

router = APIRouter(prefix="/daily_logs", tags=["daily_logs"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()

@router.post("/", response_model=schemas.DailyLogOut)
def create_or_update_log(
    log: schemas.DailyLogCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    try:
        db_log = (
            db.query(models.DailyLog)
            .options(joinedload(models.DailyLog.metric))
            .filter(models.DailyLog.user_id == user_id)
            .filter(models.DailyLog.metric_id == log.metric_id)
            .filter(models.DailyLog.log_date == log.log_date)
            .first()
        )

        if db_log:
            for field, value in log.model_dump(exclude_unset=True).items():
                setattr(db_log, field, value)

        else:
            # Force user ownership to the authenticated user
            payload = {**log.model_dump(), "user_id": user_id}
            db_log = models.DailyLog(**payload)
            db.add(db_log)

        db.commit()
        db.refresh(db_log)
        return db_log
    except Exception:
        db.rollback()
        raise


@router.get("/", response_model=list[schemas.DailyLogOut])
def get_daily_logs(
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    log_date: Optional[date] = None,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    query = db.query(models.DailyLog).options(joinedload(models.DailyLog.metric)).filter(
        models.DailyLog.deleted_at.is_(None),
        models.DailyLog.user_id == user_id,
    )  # Filter out soft-deleted logs and scope to user
    if log_date:
        query = query.filter(models.DailyLog.log_date == log_date)
    else:
        if start_date:
            query = query.filter(models.DailyLog.log_date >= start_date)
        if end_date:
            query = query.filter(models.DailyLog.log_date <= end_date)
    return query.order_by(models.DailyLog.log_date.desc()).all()

# Support no-trailing-slash path to avoid 307 redirect (some clients drop Authorization on redirect)
@router.get("", response_model=list[schemas.DailyLogOut])
def get_daily_logs_no_slash(
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    log_date: Optional[date] = None,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    return get_daily_logs(start_date=start_date, end_date=end_date, log_date=log_date, db=db, user_id=user_id)

@router.post("/clock-in")
def clock_in(metric_id: int, db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    try:
        today = date.today()
        now = datetime.now()
        
        # Get or create today's log entry
        db_log = (
            db.query(models.DailyLog)
            .filter(models.DailyLog.user_id == user_id)
            .filter(models.DailyLog.metric_id == metric_id)
            .filter(models.DailyLog.log_date == today)
            .first()
        )
        
        if not db_log:
            # Create new log entry
            db_log = models.DailyLog(
                user_id=user_id,
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
    except Exception:
        db.rollback()
        raise

@router.post("/clock-out")
def clock_out(metric_id: int, db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    try:
        today = date.today()
        now = datetime.now()
        
        # Get today's log entry
        db_log = (
            db.query(models.DailyLog)
            .filter(models.DailyLog.user_id == user_id)
            .filter(models.DailyLog.metric_id == metric_id)
            .filter(models.DailyLog.log_date == today)
            .first()
        )
        
        if not db_log:
            # Optional hardening: If there is no "today" entry, check yesterday for a running session
            from datetime import datetime as dt, time as dtime
            yesterday = today - timedelta(days=1)
            db_yesterday = (
                db.query(models.DailyLog)
                .filter(models.DailyLog.user_id == user_id)
                .filter(models.DailyLog.metric_id == metric_id)
                .filter(models.DailyLog.log_date == yesterday)
                .first()
            )
            if not db_yesterday or not db_yesterday.value_text:
                raise HTTPException(status_code=404, detail="No clock in found for today")
            
            try:
                y_clock = json.loads(db_yesterday.value_text or "{}")
            except Exception:
                y_clock = {}
            if y_clock.get("current_state") != "clocked_in" or "last_updated" not in y_clock:
                # No running session to close; behave like original response
                raise HTTPException(status_code=404, detail="No clock in found for today")
            
            # Split the running session across midnight:
            # - Close yesterday at 00:00 of today (midnight)
            # - Create a new "today" entry from 00:00 to now
            midnight_today = dt.combine(today, dtime.min)
            try:
                last_in_yesterday = dt.fromisoformat(y_clock["last_updated"])
            except Exception:
                last_in_yesterday = midnight_today
            
            # Guard against clocks that start after 'now' due to skew
            if last_in_yesterday > now:
                last_in_yesterday = now
            
            # Portion attributable to yesterday (only if last_in is before midnight)
            portion_yesterday_minutes = 0
            if last_in_yesterday < midnight_today:
                portion_yesterday_minutes = int((midnight_today - last_in_yesterday).total_seconds() / 60)
                y_sessions = y_clock.get("sessions", [])
                y_sessions.append({
                    "clock_in": last_in_yesterday.isoformat(),
                    "clock_out": midnight_today.isoformat(),
                    "duration_minutes": portion_yesterday_minutes
                })
                y_clock["sessions"] = y_sessions
                y_clock["current_state"] = "clocked_out"
                y_clock["total_duration_minutes"] = sum(s.get("duration_minutes", 0) for s in y_sessions)
                y_clock["last_updated"] = now.isoformat()
                db_yesterday.value_text = json.dumps(y_clock)
            
            # Create today's entry representing the post‑midnight portion
            portion_today_minutes = int((now - midnight_today).total_seconds() / 60)
            today_clock = {
                "current_state": "clocked_out",
                "sessions": [{
                    "clock_in": midnight_today.isoformat(),
                    "clock_out": now.isoformat(),
                    "duration_minutes": portion_today_minutes
                }],
                "total_duration_minutes": portion_today_minutes,
                "last_updated": now.isoformat()
            }
            # Use same user_id as yesterday's row to keep ownership consistent
            db_today_new = models.DailyLog(
                user_id=user_id,
                metric_id=metric_id,
                log_date=today,
                value_text=json.dumps(today_clock)
            )
            db.add(db_today_new)
            db.commit()
            db.refresh(db_today_new)
            return today_clock
        
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
    except Exception:
        db.rollback()
        raise

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
    try:
        db_log = db.query(models.DailyLog).options(joinedload(models.DailyLog.metric)).filter(
            models.DailyLog.id == log_id,
        ).first()
        
        if not db_log:
            raise HTTPException(status_code=404, detail="Daily log not found")
        
        for field, value in log_update.model_dump(exclude_unset=True).items():
            setattr(db_log, field, value)
        
        db.commit()
        db.refresh(db_log)
        return db_log
    except Exception:
        db.rollback()
        raise

@router.delete("/{log_id}")
def delete_daily_log(log_id: int, db: Session = Depends(get_db)):
    try:
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
    except Exception:
        db.rollback()
        raise
