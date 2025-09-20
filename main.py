
from datetime import date, timedelta
import os
import psycopg2
from dotenv import load_dotenv
import time
import FastAPI
from fastapi.middleware.cors import CORSMiddleware

load_dotenv()

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # loosened for dev
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"message": "Hello World"}

    def init_db():
    conn = psycopg2.connect(os.environ["DATABASE_URL"])
    cur = conn.cursor()

    with open("dbschema.sql", "r") as f:
        schema_sql = f.read()
        cur.execute(schema_sql)

    conn.commit()
    cur.close()
    conn.close()

if __name__ == "__main__":
    init_db()