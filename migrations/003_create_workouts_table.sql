-- Create workouts table if it doesn't exist
CREATE TABLE IF NOT EXISTS workouts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    ended_at TIMESTAMPTZ,
    title VARCHAR(255),
    workout_type VARCHAR(255),
    notes TEXT,
    exercises JSONB
);
