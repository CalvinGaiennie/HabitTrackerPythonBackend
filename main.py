from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os
import psycopg2

app = FastAPI()

# CORS middleware (update origins for your frontend)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "https://yourfrontend.netlify.app"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {"message": "Hello World"}
