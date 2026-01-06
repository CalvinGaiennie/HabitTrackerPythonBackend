-- Migration: Add reminders table
-- Created: 2025-12-31
-- Description: Adds a reminders table to store user notification reminders
-- NOTE: If you get "permission denied for schema public", you may need to run this as a superuser
-- or grant permissions first: GRANT CREATE ON SCHEMA public TO your_database_user;

-- Try to grant permissions (will fail silently if user doesn't have permission)
DO $$
BEGIN
    -- Try to grant schema permissions (may fail if user doesn't have permission)
    BEGIN
        GRANT USAGE ON SCHEMA public TO PUBLIC;
        GRANT CREATE ON SCHEMA public TO PUBLIC;
    EXCEPTION WHEN insufficient_privilege THEN
        -- User doesn't have permission to grant - that's okay, continue
        NULL;
    END;
END $$;

-- Create table if it doesn't exist
CREATE TABLE IF NOT EXISTS reminders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    time TIME NOT NULL,  -- Format: HH:MM:SS (e.g., 09:00:00, 19:30:00)
    is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraint if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'reminders_user_id_fkey'
    ) THEN
        ALTER TABLE reminders 
        ADD CONSTRAINT reminders_user_id_fkey 
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Create index on user_id for faster queries
CREATE INDEX IF NOT EXISTS idx_reminders_user_id ON reminders(user_id);

-- Create index on is_enabled for filtering active reminders
CREATE INDEX IF NOT EXISTS idx_reminders_is_enabled ON reminders(is_enabled);

-- Add updated_at trigger function (replace if exists)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Drop trigger if it exists, then create it
DROP TRIGGER IF EXISTS update_reminders_updated_at ON reminders;
CREATE TRIGGER update_reminders_updated_at BEFORE UPDATE ON reminders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Add comment to table
COMMENT ON TABLE reminders IS 'Stores user notification reminders for daily habit tracking';
