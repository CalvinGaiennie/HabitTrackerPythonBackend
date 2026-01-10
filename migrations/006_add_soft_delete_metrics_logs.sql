-- Add soft delete functionality to metrics and daily_logs tables
-- Add soft delete functionality to metrics and daily_logs tables
DO $$
BEGIN
    -- Add deleted_at to metrics table if it doesn't exist
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'metrics') THEN
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'metrics' 
            AND column_name = 'deleted_at'
        ) THEN
            ALTER TABLE metrics ADD COLUMN deleted_at TIMESTAMPTZ;
            RAISE NOTICE 'Successfully added deleted_at column to metrics table';
        ELSE
            RAISE NOTICE 'deleted_at column already exists in metrics table';
        END IF;
    END IF;
    
    -- Add deleted_at to daily_logs table if it doesn't exist
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'daily_logs') THEN
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'daily_logs' 
            AND column_name = 'deleted_at'
        ) THEN
            ALTER TABLE daily_logs ADD COLUMN deleted_at TIMESTAMPTZ;
            RAISE NOTICE 'Successfully added deleted_at column to daily_logs table';
        ELSE
            RAISE NOTICE 'deleted_at column already exists in daily_logs table';
        END IF;
    END IF;
END $$;
