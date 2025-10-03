from fastapi import FastAPI
from metrics import routes as metrics_routes
from daily_logs import routes as daily_logs_routes
from users import routes as users_routes
from users import models as user_models  # Import to register the model
from workouts import routes as workouts_routes
from workouts import models as workout_models  # Import to register the model
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

# Run migrations, sync, and backup on startup
run_migrations()
auto_sync_production()
auto_backup_production()

app.include_router(metrics_routes.router)
app.include_router(daily_logs_routes.router)
app.include_router(users_routes.router)
app.include_router(workouts_routes.router)


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
