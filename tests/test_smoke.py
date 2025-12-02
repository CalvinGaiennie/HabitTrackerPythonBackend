import os
from fastapi import FastAPI, Depends
from fastapi.testclient import TestClient
from typing import Generator

# Routers under test
from users import routes as users_routes
from metrics import routes as metrics_routes
from daily_logs import routes as daily_logs_routes
from workouts import routes as workouts_routes
from foods import routes as foods_routes
from exercises import routes as exercises_routes
from food_entries import routes as food_entries_routes

# DB/session and models
from db.session import SessionLocal, Base
from users import models as user_models
from metrics import models as metric_models
from daily_logs import models as daily_logs_models
from workouts import models as workout_models
from foods import models as foods_models
from exercises import models as exercises_models
from food_entries import models as food_entry_models

# Auth dependency to override in tests
from core.auth import get_current_user_id

# Optionally ensure schema is applied (works when DATABASE_URL points to Postgres)
try:
    from apply_schema import apply_schema  # psycopg2-based
except Exception:
    apply_schema = None


def override_get_current_user_id() -> int:
    # Static test user id
    return 1


def get_db() -> Generator:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def build_app() -> FastAPI:
    # Ensure schema exists (best effort)
    if apply_schema is not None:
        try:
            apply_schema()
        except Exception:
            # In CI without Postgres this may fail; tests will skip execution in that case
            pass

    # Ensure ORM metadata is loaded and tables exist if supported by the engine
    try:
        Base.metadata.create_all(bind=SessionLocal.kw['bind'])  # type: ignore[attr-defined]
    except Exception:
        # Some engines (e.g., Postgres with external migrations) may ignore this
        pass

    # Seed test user if not present
    db = SessionLocal()
    try:
        existing = db.query(user_models.User).filter(user_models.User.id == 1).first()
        if not existing:
            u = user_models.User(
                id=1,
                username="testuser",
                email="test@example.com",
                password_hash="x",
                first_name="Test",
                last_name="User",
                settings={},
            )
            db.add(u)
            db.commit()
    finally:
        db.close()

    app = FastAPI()
    app.dependency_overrides[get_current_user_id] = override_get_current_user_id
    app.include_router(users_routes.router)
    app.include_router(metrics_routes.router)
    app.include_router(daily_logs_routes.router)
    app.include_router(workouts_routes.router)
    app.include_router(foods_routes.router)
    app.include_router(exercises_routes.router)
    app.include_router(food_entries_routes.router)
    return app


def test_full_crud_smoke():
    # Skip if DATABASE_URL not configured
    assert os.getenv("DATABASE_URL"), "Set DATABASE_URL before running tests"

    app = build_app()
    client = TestClient(app)

    # 1) Users: /users/me should reflect our seeded user
    r = client.get("/users/me", headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200
    me = r.json()
    assert me["id"] == 1

    # 2) Create a metric and list it
    create_metric_payload = {
        "name": "Weight",
        "description": "Body weight",
        "data_type": "decimal",
        "unit": "kg",
        "notes_on": False,
        "active": True,
    }
    r = client.post("/metrics/", json=create_metric_payload, headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200, r.text
    metric = r.json()
    metric_id = metric["id"]

    r = client.get("/metrics/active", headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200
    assert any(m["id"] == metric_id for m in r.json())

    # 3) Create a daily log for today
    from datetime import date as _date
    today = _date.today().isoformat()
    log_payload = {
        "user_id": 1,  # accepted by schema; server uses auth scope
        "metric_id": metric_id,
        "log_date": today,
        "value_decimal": 80.5,
        "value_int": 0,
        "value_boolean": False,
        "value_text": "",
        "note": "",
    }
    r = client.post("/daily_logs/", json=log_payload, headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200, r.text

    r = client.get(f"/daily_logs?log_date={today}", headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200
    assert any(l["metric_id"] == metric_id for l in r.json())

    # 4) Foods + Entries
    food_payload = {
        "name": "Chicken Breast",
        "serving_size_amount": 100,
        "serving_size_unit": "g",
        "calories": 165,
        "protein_g": 31,
        "carbs_g": 0,
        "fat_g": 3.6,
    }
    r = client.post("/foods/", json=food_payload, headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200, r.text
    food = r.json()
    food_id = food["id"]

    r = client.get("/foods/", headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200
    assert any(f["id"] == food_id for f in r.json())

    entry_payload = {
        "user_id": 1,
        "food_id": food_id,
        "log_date": today,
        "quantity": 1,
        "calories": 165,
        "protein_g": 31,
        "carbs_g": 0,
        "fat_g": 3.6,
        "meal_type": "lunch",
        "notes": "",
    }
    r = client.post("/food_entries/", json=entry_payload, headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200, r.text

    r = client.get(f"/food_entries?log_date={today}", headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200
    assert len(r.json()) >= 1

    # 5) Exercises
    exercise_payload = {
        "user_id": 1,
        "name": "Push Up",
        "description": "Bodyweight push exercise",
        "exercise_type": "Bodyweight",
        "exercise_subtype": "Push",
        "primary_muscles": ["Chest", "Triceps"],
        "secondary_muscles": ["Shoulders"],
        "tags": ["Push", "Compound"],
        "equipment": "Bodyweight",
        "equipment_modifiers": [],
        "injury_pain": "",
    }
    r = client.post("/exercises/", json=exercise_payload, headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200, r.text

    r = client.get("/exercises/", headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200
    assert any(ex["name"] == "Push Up" for ex in r.json())

    # 6) Workouts
    workout_payload = {
        "title": "Upper Body",
        "workout_types": ["Lifting"],
        "notes": "Test session",
        "exercises": [{"name": "Push Up", "sets": [{"reps": 10}]}],
    }
    r = client.post("/workouts/", json=workout_payload, headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200, r.text

    r = client.get("/workouts/", headers={"Authorization": "Bearer dummy"})
    assert r.status_code == 200
    assert len(r.json()) >= 1



