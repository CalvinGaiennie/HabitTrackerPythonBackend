-- Add soft delete functionality to workouts table
ALTER TABLE workouts ADD COLUMN deleted_at TIMESTAMPTZ;
