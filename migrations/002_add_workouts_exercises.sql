-- Add exercises JSONB column to workouts table
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS exercises JSONB;
