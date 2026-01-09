#!/usr/bin/env python3
"""
Apply DBSchema.sql to database - simple version without config dependency
"""
import os
import psycopg2
from dotenv import load_dotenv

def apply_schema():
    """Run the complete DBSchema.sql file"""
    load_dotenv('.env')
    DATABASE_URL = os.getenv('DATABASE_URL')
    
    # Fix password if missing
    if DATABASE_URL and '@' in DATABASE_URL:
        auth_part = DATABASE_URL.split('@')[0].replace('postgresql://', '')
        if ':' not in auth_part or auth_part.split(':')[1] == '':
            # Missing password, try adding 'postgres' password
            user = auth_part.split(':')[0] if ':' in auth_part else auth_part
            host_part = DATABASE_URL.split('@')[1]
            DATABASE_URL = f"postgresql://{user}:postgres@{host_part}"
    
    if not DATABASE_URL:
        print("❌ DATABASE_URL not found in .env")
        return
    
    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor()
    
    try:
        print("🔄 Applying database schema from DBSchema.sql...")
        
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
