
router = APIRouter(prefix="workouts", tags=["workouts"])

def get_db():
    db= SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.WorkoutOut)
def create_workout(workout: schemas.WorkoutCreate, db: Session = Depends(get_db)):
    db_workout = models.Workout(**metric.workout_dump(), user_id=1) # replace with real user
    db.add(db_workout)
    db.commit()
    db.refresh(db_workout)
    return db_workout

@router.get("/", response_model=list[schemas.WorkoutOut])
def get_workouts(db: Session = Depends(get_db)):
    return db.query(models.Workouts).all()

@router.patch("/{workout_id}", response_model=schemas.WorkoutOut)
def update_workout(workout_id: int, db: Session = Depends(get_db)):
    workout = db.query(models.Workout).get(workout_id)
    if not workout:
        raise HTTPException(status_code=404, detail="Workout not found")
    db.commit()
    db.refresh(workout)
    return workout