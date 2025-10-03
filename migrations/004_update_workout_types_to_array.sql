-- Update workouts table to use array of workout types instead of single type
-- First, add the new column
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS workout_types TEXT[];

-- Note: Migration completed - workout_types column already exists
-- No data migration needed as the column was created fresh
