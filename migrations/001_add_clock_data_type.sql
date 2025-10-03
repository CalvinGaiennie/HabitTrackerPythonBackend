-- Migration: Add clock data type to metrics table
-- Date: 2024-01-15
-- Description: Adds 'clock' as a valid data_type option for metrics

-- Check if the constraint exists and update it
DO $$
BEGIN
    -- Check if metrics table exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'metrics') THEN
        -- Drop existing constraint if it exists
        IF EXISTS (
            SELECT 1 FROM pg_constraint 
            WHERE conrelid = 'metrics'::regclass 
            AND conname LIKE '%data_type%'
        ) THEN
            ALTER TABLE metrics DROP CONSTRAINT IF EXISTS metrics_data_type_check;
        END IF;
        
        -- Add new constraint with clock data type
        ALTER TABLE metrics ADD CONSTRAINT metrics_data_type_check 
        CHECK (data_type IN ('int', 'boolean', 'text', 'scale', 'decimal', 'clock'));
        
        RAISE NOTICE 'Successfully added clock data type to metrics table';
    ELSE
        RAISE NOTICE 'Metrics table does not exist - run initial schema first';
    END IF;
END $$;
