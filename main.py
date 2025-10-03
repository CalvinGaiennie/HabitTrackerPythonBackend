from fastapi import FastAPI
from metrics import routes as metrics_routes
from daily_logs import routes as daily_logs_routes
from users import routes as users_routes
from users import models as user_models  # Import to register the model
from fastapi.middleware.cors import CORSMiddleware
import os
import psycopg2

app = FastAPI()

app.include_router(metrics_routes.router)
app.include_router(daily_logs_routes.router)
app.include_router(users_routes.router)


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
