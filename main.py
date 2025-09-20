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


@app.on_event("startup")
def init_db():
    """Initialize database schema on startup and log existing tables."""
    conn = psycopg2.connect(os.environ["DATABASE_URL"])
    cur = conn.cursor()

    # Run schema file (safe if it uses CREATE TABLE IF NOT EXISTS)
    try:
        with open("DBschema.sql", "r") as f:
            schema_sql = f.read()
            cur.execute(schema_sql)
        conn.commit()
        print("✅ DBschema.sql executed")
    except Exception as e:
        print("⚠️ Error running DBschema.sql:", e)

    # Log all existing tables
    cur.execute("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        ORDER BY table_name;
    """)
    tables = [row[0] for row in cur.fetchall()]
    print("📋 Tables in database:", tables)

    cur.close()
    conn.close()
