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
    return db.query(models.Metric).filter(models.Metric.active == True).all()

@router.delete("/{metric_id}")
def deactivate_metric(metric_id: int, db: Session = Depends(get_db)):
    metric = db.query(models.Metric).get(metric_id)
    if not metric:
        raise HTTPException(status_code=404, detail="Metric not found")
    metric.active = False
    db.commit()
    return {"message": "Metric deactivated"}
