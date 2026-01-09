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
        # Try PRODUCTION_ENV first, then PRODUCTION_DATABASE_URL
        prod_url = os.getenv('PRODUCTION_ENV') or os.getenv('PRODUCTION_DATABASE_URL')
        # Use DATABASE_URL from .env (which should be the local DB)
        local_url = os.getenv('DATABASE_URL')
        
        if not prod_url:
            print("⚠️  PRODUCTION_ENV or PRODUCTION_DATABASE_URL not found in .env file")
            print("   Please add one of these to your .env file:")
            print("   PRODUCTION_ENV=postgresql://user:password@host:port/database")
            print("   OR")
            print("   PRODUCTION_DATABASE_URL=postgresql://user:password@host:port/database")
            return
        
        if not local_url:
            print("⚠️  DATABASE_URL not found in .env file")
            print("   DATABASE_URL should be your local database connection string")
            return
        
        # Try to connect even if password might be missing (some local setups allow this)
        # We'll catch the error and provide helpful message if it fails
        
        print("🔄 Syncing production data to local database...")
        print(f"   Production: {prod_url.split('@')[1] if '@' in prod_url else '***'}")
        print(f"   Local: {local_url.split('@')[1] if '@' in local_url else local_url}")
        
        # Connect to databases first
        try:
            prod_conn = psycopg2.connect(prod_url)
        except Exception as e:
            print(f"❌ Failed to connect to production database: {e}")
            return
        
        try:
            local_conn = psycopg2.connect(local_url)
        except psycopg2.OperationalError as e:
            # If connection failed due to missing password, try with docker-compose default password
            if "no password supplied" in str(e) or "password authentication failed" in str(e):
                print("⚠️  Connection failed, trying with docker-compose default password (postgres)...")
                # Try to construct URL with password from docker-compose.yml default
                if '@' in local_url:
                    # Extract parts and add password
                    parts = local_url.split('@')
                    auth = parts[0].replace('postgresql://', '')
                    if ':' not in auth or auth.split(':')[1] == '':
                        # Missing password, try adding 'postgres' password
                        user = auth.split(':')[0] if ':' in auth else auth
                        host_part = parts[1]
                        local_url_with_pass = f"postgresql://{user}:postgres@{host_part}"
                        try:
                            local_conn = psycopg2.connect(local_url_with_pass)
                            print("✅ Connected using default password")
                        except:
                            print(f"❌ Failed to connect to local database: {e}")
                            print("   Please update DATABASE_URL in .env to include password:")
                            print("   DATABASE_URL=postgresql://postgres:postgres@localhost:5434/habittracker")
                            prod_conn.close()
                            return
                    else:
                        print(f"❌ Failed to connect to local database: {e}")
                        prod_conn.close()
                        return
                else:
                    print(f"❌ Failed to connect to local database: {e}")
                    prod_conn.close()
                    return
            else:
                print(f"❌ Failed to connect to local database: {e}")
                prod_conn.close()
                return
        
        prod_cursor = prod_conn.cursor()
        local_cursor = local_conn.cursor()
        
        # Get tables to sync from production
        prod_cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name")
        prod_tables = [row[0] for row in prod_cursor.fetchall()]
        
        # Get local tables
        local_cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name")
        local_tables_set = {row[0] for row in local_cursor.fetchall()}
        
        # Map production table names to local table names (handle name differences)
        table_mapping = {}
        for prod_table in prod_tables:
            # Check if table exists locally with same name
            if prod_table in local_tables_set:
                table_mapping[prod_table] = prod_table
            # Handle known name differences
            elif prod_table == "workout" and "workouts" in local_tables_set:
                table_mapping[prod_table] = "workouts"
            elif prod_table == "workouts" and "workout" in local_tables_set:
                table_mapping[prod_table] = "workout"
            else:
                # Table doesn't exist locally - skip it with a warning
                print(f"⚠️  Skipping table '{prod_table}' - not found in local database")
        
        tables = [t for t in prod_tables if t in table_mapping]
        
        print(f"📋 Syncing {len(tables)} tables...")
        
        # Truncate all tables first (CASCADE handles foreign keys)
        print("   Clearing local tables...")
        for prod_table in tables:
            local_table = table_mapping[prod_table]
            try:
                local_cursor.execute(f"TRUNCATE TABLE {local_table} RESTART IDENTITY CASCADE;")
            except Exception as e:
                print(f"   ⚠️  Could not truncate {local_table}: {e}")
        
        local_conn.commit()
        
        # Define insertion order (parent tables first, then child tables)
        # This ensures foreign key constraints are satisfied
        insertion_order = [
            'users', 'metrics', 'goals', 'foods', 'exercises', 'stripe_customers',
            'daily_logs', 'workouts', 'workout', 'food_entry', 'exercise', 'set_entry',
            'metric_history', 'goal_history', 'schema_migrations', 'reminders', 'discount_codes', 'discount_code_redemptions'
        ]
        
        # Sort tables by insertion order, then add any remaining tables
        ordered_tables = []
        for table_name in insertion_order:
            if table_name in tables:
                ordered_tables.append(table_name)
        # Add any tables not in the order list
        for table_name in tables:
            if table_name not in ordered_tables:
                ordered_tables.append(table_name)
        
        # Now insert data in correct order
        for prod_table in ordered_tables:
            local_table = table_mapping[prod_table]
            
            # Copy data from production
            prod_cursor.execute(f"SELECT * FROM {prod_table};")
            rows = prod_cursor.fetchall()
            
            if rows:
                # Get column info from both tables to ensure they match
                prod_cursor.execute(f"SELECT column_name FROM information_schema.columns WHERE table_name = '{prod_table}' ORDER BY ordinal_position;")
                prod_columns = [row[0] for row in prod_cursor.fetchall()]
                
                local_cursor.execute(f"SELECT column_name FROM information_schema.columns WHERE table_name = '{local_table}' ORDER BY ordinal_position;")
                local_columns = [row[0] for row in local_cursor.fetchall()]
                
                # Find common columns
                common_columns = [col for col in prod_columns if col in local_columns]
                
                if not common_columns:
                    print(f"   ⚠️  {prod_table} -> {local_table}: No matching columns, skipping")
                    continue
                
                # Get only the columns that exist in both tables
                prod_cursor.execute(f"SELECT {', '.join(common_columns)} FROM {prod_table};")
                rows = prod_cursor.fetchall()
                
                # Convert rows to handle JSON and other types
                # Get column types to handle arrays properly
                prod_cursor.execute(f"""
                    SELECT column_name, data_type 
                    FROM information_schema.columns 
                    WHERE table_name = '{prod_table}' 
                    ORDER BY ordinal_position
                """)
                column_info = {row[0]: row[1] for row in prod_cursor.fetchall()}
                
                processed_rows = []
                for row in rows:
                    processed_row = []
                    for idx, value in enumerate(row):
                        col_name = common_columns[idx]
                        col_type = column_info.get(col_name, '')
                        
                        if value is None:
                            processed_row.append(None)
                        elif isinstance(value, dict):
                            processed_row.append(json.dumps(value))
                        elif isinstance(value, (list, tuple)) and 'ARRAY' not in col_type.upper():
                            # Only convert to JSON if it's not a PostgreSQL array type
                            processed_row.append(json.dumps(value))
                        else:
                            # Keep lists/tuples as-is for PostgreSQL arrays
                            processed_row.append(value)
                    processed_rows.append(tuple(processed_row))
                
                # Insert data using only common columns
                placeholders = ', '.join(['%s'] * len(common_columns))
                columns_str = ', '.join(common_columns)
                
                local_cursor.executemany(f"INSERT INTO {local_table} ({columns_str}) VALUES ({placeholders});", processed_rows)
                print(f"   ✅ {prod_table} -> {local_table}: {len(rows)} rows")
            else:
                print(f"   ⚠️  {prod_table}: No data")
        
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
