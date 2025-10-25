#!/usr/bin/env python3
"""
Apply DBSchema.sql to database on every run
This ensures schema changes are always applied
"""
import os
import psycopg2
from config import settings

def apply_schema():
    """Run the complete DBSchema.sql file"""
    DATABASE_URL = settings.DATABASE_URL
    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor()
    
    try:
        print("🔄 Applying database schema from DBSchema.sql...")
        
        # First, handle the food -> foods table rename if needed
        cur.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'food'
            );
        """)
        food_table_exists = cur.fetchone()[0]
        
        if food_table_exists:
            print("  🔄 Renaming 'food' table to 'foods'...")
            cur.execute("ALTER TABLE food RENAME TO foods;")
            conn.commit()
            print("  ✅ Table renamed successfully")
        
        # Read and execute the schema file
        schema_path = os.path.join(os.path.dirname(__file__), 'DBSchema.sql')
        with open(schema_path, 'r') as f:
            schema_sql = f.read()
        
        # Execute the entire schema
        cur.execute(schema_sql)
        conn.commit()
        
        print("✅ Database schema applied successfully")
        
    except Exception as e:
        print(f"❌ Schema application failed: {e}")
        conn.rollback()
        raise
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    apply_schema()

