#!/usr/bin/env python3
"""
Database Migration Runner
Runs SQL migration files in order
"""
import os
import psycopg2
import glob

# Get database URL from environment or use default
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5432/habit_tracker')

def run_migrations():
    """Run all migration files in order"""
    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor()
    
    try:
        # Create migrations tracking table if it doesn't exist
        cur.execute("""
            CREATE TABLE IF NOT EXISTS schema_migrations (
                id SERIAL PRIMARY KEY,
                filename VARCHAR(255) UNIQUE NOT NULL,
                executed_at TIMESTAMP DEFAULT NOW()
            );
        """)
        conn.commit()
        
        # Get all migration files
        migration_dir = os.path.join(os.path.dirname(__file__), 'migrations')
        migration_files = sorted(glob.glob(os.path.join(migration_dir, '*.sql')))
        
        for migration_file in migration_files:
            filename = os.path.basename(migration_file)
            
            # Check if migration already ran
            cur.execute("SELECT 1 FROM schema_migrations WHERE filename = %s", (filename,))
            if cur.fetchone():
                print(f"✓ Migration {filename} already executed")
                continue
            
            # Run migration
            print(f"🔄 Running migration: {filename}")
            with open(migration_file, 'r') as f:
                sql_content = f.read()
            
            cur.execute(sql_content)
            conn.commit()
            
            # Record migration
            cur.execute("INSERT INTO schema_migrations (filename) VALUES (%s)", (filename,))
            conn.commit()
            
            print(f"✅ Migration {filename} completed successfully")
            
    except Exception as e:
        print(f"❌ Migration failed: {e}")
        conn.rollback()
        raise
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    run_migrations()
