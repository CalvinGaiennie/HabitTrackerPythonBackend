-- Add soft delete functionality to metrics and daily_logs tables
ALTER TABLE metrics ADD COLUMN deleted_at TIMESTAMPTZ;
ALTER TABLE daily_logs ADD COLUMN deleted_at TIMESTAMPTZ;
