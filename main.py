from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from db import get_db
from fastapi.middleware.cors import CORSMiddleware
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173","https://cghabittracker.netlify.app"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def Hello():
    return {"message": "Hello Worlddd"}
