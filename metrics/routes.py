from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from db.session import SessionLocal
from core.auth import get_current_user_id
from users import models as user_models
from core.tier import get_user_tier, should_bypass_tier_restrictions


router = APIRouter(prefix="/metrics", tags=["metrics"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.MetricOut)
def create_metric(
    metric: schemas.MetricCreate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    # Enforce free-tier limit: max 4 metrics total
    user = db.query(user_models.User).filter(user_models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Check if user bypasses tier restrictions
    if should_bypass_tier_restrictions(user):
        # User bypasses restrictions - skip tier limit check
        pass
    else:
        tier = get_user_tier(db, user)
        if tier == "free":
            existing_count = db.query(models.Metric).filter(models.Metric.user_id == user_id).count()
            if existing_count >= 4:
                raise HTTPException(
                    status_code=403,
                    detail={
                        "code": "limit.metrics.max",
                        "message": "Free plan limit: max 4 metrics. Upgrade to add more.",
                    },
                )
    db_metric = models.Metric(**metric.model_dump(), user_id=user_id)
    db.add(db_metric)
    db.commit()
    db.refresh(db_metric)
    return db_metric

@router.get("/", response_model=list[schemas.MetricOut])
def get_metrics(db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    return (
        db.query(models.Metric)
        .filter(models.Metric.user_id == user_id)
        .filter(models.Metric.active == True)
        .all()
    )

@router.get("/active", response_model=list[schemas.MetricOut])
def get_active_metrics(db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    return (
        db.query(models.Metric)
        .filter(models.Metric.user_id == user_id)
        .filter(models.Metric.active.is_(True))
        .all()
    )

@router.get("/all", response_model=list[schemas.MetricOut])
def get_all_metrics(db: Session = Depends(get_db), user_id: int = Depends(get_current_user_id)):
    """Get all metrics including inactive ones (for management pages)"""
    return (
        db.query(models.Metric)
        .filter(models.Metric.user_id == user_id)
        .all()
    )


@router.patch("/{metric_id}/activate", response_model=schemas.MetricOut)
def update_metric_activate(
    metric_id: int,
    active: bool,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    metric = (
        db.query(models.Metric)
        .filter(models.Metric.id == metric_id, models.Metric.user_id == user_id)
        .first()
    )
    if not metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    metric.active = active
    db.commit()
    db.refresh(metric)
    return metric

@router.put("/{metric_id}", response_model=schemas.MetricOut)
def update_metric(
    metric_id: int,
    metric_update: schemas.MetricUpdate,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    metric = (
        db.query(models.Metric)
        .filter(models.Metric.id == metric_id, models.Metric.user_id == user_id)
        .first()
    )
    if not metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    
    for field, value in metric_update.model_dump(exclude_unset=True).items():
        setattr(metric, field, value)
    
    db.commit()
    db.refresh(metric)
    return metric

@router.delete("/{metric_id}")
def delete_metric(
    metric_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    metric = (
        db.query(models.Metric)
        .filter(models.Metric.id == metric_id, models.Metric.user_id == user_id)
        .first()
    )
    
    if not metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    
    # Soft delete: set deleted_at timestamp
    from datetime import datetime
    metric.deleted_at = datetime.utcnow()
    db.commit()
    return {"message": "Metric deleted successfully"}