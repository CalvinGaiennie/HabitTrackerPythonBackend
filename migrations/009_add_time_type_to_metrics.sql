-- Migration: Add time_type column to metrics table
-- Date: 2025-01-XX
-- Description: Adds time_type column to metrics table for tracking daily vs weekly metrics

DO $$
BEGIN
    -- Check if metrics table exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'metrics') THEN
        -- Add time_type column if it doesn't exist
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'metrics' 
            AND column_name = 'time_type'
        ) THEN
            ALTER TABLE metrics ADD COLUMN time_type VARCHAR(255);
            RAISE NOTICE 'Successfully added time_type column to metrics table';
        ELSE
            RAISE NOTICE 'time_type column already exists in metrics table';
        END IF;
    ELSE
        RAISE NOTICE 'Metrics table does not exist - run initial schema first';
    END IF;
END $$;
