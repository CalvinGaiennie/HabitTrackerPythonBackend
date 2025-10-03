-- Update workouts table to use array of workout types instead of single type
-- First, add the new column
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS workout_types TEXT[];

-- Migrate existing data (if any)
-- This will copy the single workout_type to the new array column
UPDATE workouts 
SET workout_types = ARRAY[workout_type] 
WHERE workout_type IS NOT NULL AND workout_types IS NULL;

-- Drop the old column (commented out for safety - uncomment after verifying data)
-- ALTER TABLE workouts DROP COLUMN IF EXISTS workout_type;
