#!/usr/bin/env python3
"""
Auto-sync production data to local database (once per day)
"""
import psycopg2
import json
import os
from datetime import datetime, date
from dotenv import load_dotenv

def get_backup_status():
    """Check if we've already backed up today"""
    status_file = 'last_backup.txt'
    if not os.path.exists(status_file):
        return False
    
    try:
        with open(status_file, 'r') as f:
            last_backup_date = f.read().strip()
        return last_backup_date == str(date.today())
    except:
        return False

def mark_backed_up():
    """Mark that we've backed up today"""
    with open('last_backup.txt', 'w') as f:
        f.write(str(date.today()))

def sync_production_data():
    """Sync production data to local database"""
    try:
        # Load .env
        load_dotenv('.env')
        prod_url = os.getenv('PRODUCTION_ENV')
        local_url = "postgresql://postgres:postgres@localhost:5432/habittracker"
        
        if not prod_url:
            print("⚠️  PRODUCTION_ENV not found in .env file - skipping sync")
            return
        
        print("🔄 Syncing production data to local database...")
        
        # Connect to databases
        prod_conn = psycopg2.connect(prod_url)
        local_conn = psycopg2.connect(local_url)
        
        prod_cursor = prod_conn.cursor()
        local_cursor = local_conn.cursor()
        
        # Get tables
        prod_cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
        tables = [row[0] for row in prod_cursor.fetchall()]
        
        print(f"📋 Syncing {len(tables)} tables...")
        
        for table in tables:
            # Clear local table
            local_cursor.execute(f"TRUNCATE TABLE {table} RESTART IDENTITY CASCADE;")
            
            # Copy data from production
            prod_cursor.execute(f"SELECT * FROM {table};")
            rows = prod_cursor.fetchall()
            
            if rows:
                # Get column info
                prod_cursor.execute(f"SELECT column_name FROM information_schema.columns WHERE table_name = '{table}' ORDER BY ordinal_position;")
                columns = [row[0] for row in prod_cursor.fetchall()]
                
                # Convert rows to handle JSON
                processed_rows = []
                for row in rows:
                    processed_row = []
                    for value in row:
                        if isinstance(value, dict):
                            processed_row.append(json.dumps(value))
                        else:
                            processed_row.append(value)
                    processed_rows.append(tuple(processed_row))
                
                # Insert data
                placeholders = ', '.join(['%s'] * len(columns))
                columns_str = ', '.join(columns)
                
                local_cursor.executemany(f"INSERT INTO {table} ({columns_str}) VALUES ({placeholders});", processed_rows)
                print(f"   ✅ {table}: {len(rows)} rows")
            else:
                print(f"   ⚠️  {table}: No data")
        
        # Commit and close
        local_conn.commit()
        prod_conn.close()
        local_conn.close()
        
        print("✅ Production data synced successfully!")
        
    except Exception as e:
        print(f"❌ Error syncing production data: {e}")

def backup_production_data():
    """Backup production data to local database (once per day)"""
    if get_backup_status():
        print("✅ Already backed up today - skipping backup")
        return
    
    print(f"🔄 First backup of {date.today()} - backing up production data...")
    sync_production_data()
    mark_backed_up()

def auto_sync():
    """Always sync production data to local database"""
    print("🔄 Syncing production data...")
    sync_production_data()

if __name__ == "__main__":
    auto_sync()
