-- Add soft delete functionality to workouts table
DO $$
BEGIN
    -- Check if workouts table exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'workouts') THEN
        -- Add deleted_at column if it doesn't exist
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'workouts' 
            AND column_name = 'deleted_at'
        ) THEN
            ALTER TABLE workouts ADD COLUMN deleted_at TIMESTAMPTZ;
            RAISE NOTICE 'Successfully added deleted_at column to workouts table';
        ELSE
            RAISE NOTICE 'deleted_at column already exists in workouts table';
        END IF;
    ELSE
        RAISE NOTICE 'Workouts table does not exist - run initial schema first';
    END IF;
END $$;
