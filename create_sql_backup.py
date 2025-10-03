#!/usr/bin/env python3
"""
Create SQL dump backup of production database
"""
import os
import subprocess
import sys
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

def create_sql_backup():
    """Create SQL dump backup"""
    try:
        # Load .env
        load_dotenv('.env')
        prod_url = os.getenv('PRODUCTION_ENV')
        
        if not prod_url:
            print("❌ PRODUCTION_ENV not found in .env file")
            return
        
        # Create backups directory
        backups_dir = 'backups'
        if not os.path.exists(backups_dir):
            os.makedirs(backups_dir)
            print(f"📁 Created backups directory: {backups_dir}")
        
        # Generate backup filename with timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = os.path.join(backups_dir, f"production_backup_{timestamp}.sql")
        
        print(f"🔄 Creating SQL backup: {backup_file}")
        
        # Extract connection details from URL
        # Format: postgresql://user:pass@host:port/database
        try:
            url_parts = prod_url.replace('postgresql://', '').split('@')
            if len(url_parts) != 2:
                raise ValueError("Invalid URL format")
                
            auth_part = url_parts[0]
            host_db_part = url_parts[1]
            
            # Handle password with special characters
            if ':' in auth_part:
                username, password = auth_part.split(':', 1)  # Split only on first ':'
            else:
                username = auth_part
                password = ""
            
            if '/' in host_db_part:
                host_port, database = host_db_part.split('/', 1)
            else:
                host_port = host_db_part
                database = ""
            
            if ':' in host_port:
                host, port = host_port.split(':')
            else:
                host = host_port
                port = "5432"
                
        except Exception as e:
            print(f"❌ Error parsing database URL: {e}")
            print(f"URL: {prod_url[:50]}...")
            return
        
        # Set environment variable for password
        env = os.environ.copy()
        env['PGPASSWORD'] = password
        
        # Create SQL dump using pg_dump
        # Try different pg_dump paths (prioritize PostgreSQL 17)
        pg_dump_paths = [
            '/opt/homebrew/opt/postgresql@17/bin/pg_dump',  # PostgreSQL 17 (preferred)
            'pg_dump',  # System PATH
            '/opt/homebrew/bin/pg_dump',  # Homebrew ARM
            '/usr/local/bin/pg_dump',  # Homebrew Intel
            '/opt/homebrew/opt/postgresql@14/bin/pg_dump'  # PostgreSQL 14
        ]
        
        pg_dump_cmd = None
        for path in pg_dump_paths:
            if os.path.exists(path) or subprocess.run(['which', path], capture_output=True).returncode == 0:
                pg_dump_cmd = path
                break
        
        if not pg_dump_cmd:
            print("❌ pg_dump not found. Please install PostgreSQL tools.")
            return
        
        dump_command = [
            pg_dump_cmd,
            f'--host={host}',
            f'--port={port}',
            f'--username={username}',
            f'--dbname={database}',
            '--verbose',
            '--clean',
            '--no-owner',
            '--no-privileges',
            f'--file={backup_file}'
        ]
        
        print(f"📥 Running: {' '.join(dump_command[:4])}...")
        result = subprocess.run(dump_command, env=env, capture_output=True, text=True)
        
        if result.returncode == 0:
            print(f"✅ SQL backup created successfully: {backup_file}")
            
            # Get file size
            file_size = os.path.getsize(backup_file)
            size_mb = file_size / (1024 * 1024)
            print(f"📊 Backup size: {size_mb:.2f} MB")
            
            # Mark as backed up
            mark_backed_up()
            
            # Clean up old backups (keep last 7 days)
            cleanup_old_backups(backups_dir)
            
        else:
            print(f"❌ Backup failed: {result.stderr}")
            
    except Exception as e:
        print(f"❌ Error creating backup: {e}")

def cleanup_old_backups(backups_dir):
    """Clean up backups older than 7 days"""
    try:
        import time
        current_time = time.time()
        seven_days_ago = current_time - (7 * 24 * 60 * 60)
        
        for filename in os.listdir(backups_dir):
            if filename.startswith('production_backup_') and filename.endswith('.sql'):
                file_path = os.path.join(backups_dir, filename)
                file_time = os.path.getmtime(file_path)
                
                if file_time < seven_days_ago:
                    os.remove(file_path)
                    print(f"🗑️  Cleaned up old backup: {filename}")
                    
    except Exception as e:
        print(f"⚠️  Error cleaning up old backups: {e}")

def auto_backup():
    """Auto-backup if not already done today"""
    if get_backup_status():
        print("✅ Already backed up today - skipping")
        return
    
    print(f"🔄 First backup of {date.today()} - creating SQL backup...")
    create_sql_backup()

if __name__ == "__main__":
    auto_backup()
