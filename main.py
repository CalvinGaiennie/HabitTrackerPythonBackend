from fastapi import FastAPI
from metrics import routes as metrics_routes
from daily_logs import routes as daily_logs_routes
from users import routes as users_routes
from users import models as user_models  # Import to register the model
from workouts import routes as workouts_routes
from workouts import models as workout_models  
# Import to register the model
from exercises import routes as exercises_routes
from exercises import models as exercises_models
from stripe import routes as stripe_routes

from fastapi.middleware.cors import CORSMiddleware
import os
import psycopg2
import subprocess
import sys

app = FastAPI()

# Run database migrations on startup
def run_migrations():
    try:
        print("🔄 Running database migrations...")
        result = subprocess.run([sys.executable, "run_migrations.py"], 
                              capture_output=True, text=True, check=True)
        print("✅ Database migrations completed successfully")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"❌ Migration failed: {e}")
        print(f"Error output: {e.stderr}")
        # Don't fail the app startup, just log the error
    except Exception as e:
        print(f"❌ Migration error: {e}")
        # Don't fail the app startup, just log the error

# Auto-sync production data (every startup)
def auto_sync_production():
    try:
        print("🔄 Syncing production data...")
        result = subprocess.run([sys.executable, "sync_production_data.py"], 
                              capture_output=True, text=True, check=True)
        print("✅ Production data sync completed")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"⚠️  Production sync failed: {e}")
        print(f"Error output: {e.stderr}")
        # Don't fail the app startup, just log the error
    except Exception as e:
        print(f"⚠️  Production sync error: {e}")
        # Don't fail the app startup, just log the error

# Auto-backup production data (once per day)
def auto_backup_production():
    try:
        print("🔄 Checking for production backup...")
        result = subprocess.run([sys.executable, "create_sql_backup.py"], 
                              capture_output=True, text=True, check=True)
        print("✅ Production backup completed")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"⚠️  Production backup failed: {e}")
        print(f"Error output: {e.stderr}")
        # Don't fail the app startup, just log the error
    except Exception as e:
        print(f"⚠️  Production backup error: {e}")
        # Don't fail the app startup, just log the error

# Apply database schema on startup
def apply_database_schema():
    try:
        print("🔄 Applying database schema...")
        result = subprocess.run([sys.executable, "apply_schema.py"], 
                              capture_output=True, text=True, check=True)
        print("✅ Database schema applied successfully")
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"❌ Schema application failed: {e}")
        print(f"Error output: {e.stderr}")
        # Don't fail the app startup, just log the error
    except Exception as e:
        print(f"❌ Schema application error: {e}")
        # Don't fail the app startup, just log the error

# Run schema on every startup
apply_database_schema()

# Auto-backup production database (once per day)
auto_backup_production()

print("🚀 App started successfully")

app.include_router(metrics_routes.router)
app.include_router(daily_logs_routes.router)
app.include_router(users_routes.router)
app.include_router(workouts_routes.router)
app.include_router(exercises_routes.router)
app.include_router(stripe_routes.router)


# CORS middleware (allows all localhost ports for development)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://localhost:5174", "https://cghabittracker.netlify.app", "http://127.0.0.1:5173", "http://127.0.0.1:5174"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {"message": "Hello World"}

@app.get("/health")
def health_check():
    return {"status": "healthy", "message": "Backend is running"}

@app.get("/test-db")
def test_database():
    try:
        from db.session import SessionLocal
        from sqlalchemy import text
        db = SessionLocal()
        # Simple query to test database connection
        result = db.execute(text("SELECT 1 as test")).fetchone()
        db.close()
        return {"status": "database_connected", "test_result": result[0] if result else None}
    except Exception as e:
        return {"status": "database_error", "error": str(e)}

@app.get("/test-metrics")
def test_metrics_endpoint():
    try:
        from db.session import SessionLocal
        from metrics import models
        db = SessionLocal()
        # Test the exact query from the metrics route
        metrics = db.query(models.Metric).filter(
            models.Metric.active == True
        ).all()
        db.close()
        return {"status": "metrics_query_success", "count": len(metrics)}
    except Exception as e:
        return {"status": "metrics_query_error", "error": str(e)}

# Add error handling middleware
from fastapi.responses import JSONResponse

@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    return JSONResponse(
        status_code=500,
        content={"error": "Internal server error", "detail": str(exc)}
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
