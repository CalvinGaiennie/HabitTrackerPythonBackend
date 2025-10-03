from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from db.session import SessionLocal


router = APIRouter(prefix="/metrics", tags=["metrics"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.MetricOut)
def create_metric(metric: schemas.MetricCreate, db: Session = Depends(get_db)):
    db_metric = models.Metric(**metric.model_dump(), user_id=1)  # replace with real user
    db.add(db_metric)
    db.commit()
    db.refresh(db_metric)
    return db_metric

@router.get("/", response_model=list[schemas.MetricOut])
def get_metrics(db: Session = Depends(get_db)):
    return db.query(models.Metric).filter(
        models.Metric.active == True,
        models.Metric.deleted_at.is_(None)
    ).all()

@router.get("/active", response_model=list[schemas.MetricOut])
def get_active_metrics(db: Session = Depends(get_db)):
    return db.query(models.Metric).filter(
        models.Metric.active.is_(True),
        models.Metric.deleted_at.is_(None)
    ).all()


@router.patch("/{metric_id}/activate", response_model=schemas.MetricOut)
def update_metric_activate(metric_id: int, active: bool, db: Session = Depends(get_db)):
    metric = db.query(models.Metric).filter(
        models.Metric.id == metric_id,
        models.Metric.deleted_at.is_(None)
    ).first()
    if not metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    metric.active = active
    db.commit()
    db.refresh(metric)
    return metric

@router.put("/{metric_id}", response_model=schemas.MetricOut)
def update_metric(metric_id: int, metric_update: schemas.MetricUpdate, db: Session = Depends(get_db)):
    metric = db.query(models.Metric).filter(
        models.Metric.id == metric_id,
        models.Metric.deleted_at.is_(None)
    ).first()
    if not metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    
    for field, value in metric_update.dict(exclude_unset=True).items():
        setattr(metric, field, value)
    
    db.commit()
    db.refresh(metric)
    return metric

@router.delete("/{metric_id}")
def delete_metric(metric_id: int, db: Session = Depends(get_db)):
    metric = db.query(models.Metric).filter(
        models.Metric.id == metric_id,
        models.Metric.deleted_at.is_(None)
    ).first()
    
    if not metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    
    # Soft delete: set deleted_at timestamp
    from datetime import datetime
    metric.deleted_at = datetime.utcnow()
    db.commit()
    return {"message": "Metric deleted successfully"}