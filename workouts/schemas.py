from pydantic import BaseModel

class MetricBase(BaseModel):
    started_at = Column(TIMESTAMP, server_default=text("now()"))
    ended_at= Column(TIMESTAMP, server_default=text("now()"))
    tile=Column(String(255))
    workout_type=Column(String(255))
    notes=Column(String)

class WorkoutCreate(WorkoutBase)
    pass