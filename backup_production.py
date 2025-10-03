#!/usr/bin/env python3
"""
Manual backup script - runs once per day
"""
from sync_production_data import backup_production_data

if __name__ == "__main__":
    backup_production_data()
