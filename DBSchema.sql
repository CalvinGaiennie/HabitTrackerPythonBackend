--USERS
---------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Store hashed passwords, never plain text
    
    -- User profile
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    last_login TIMESTAMPTZ,
    
    -- User status
    is_verified BOOLEAN DEFAULT false, -- Email verification
    
    -- User settings (flexible JSON storage)
    settings JSONB DEFAULT '{}', -- Store user preferences, theme, etc.
    
    -- Constraints
    CONSTRAINT users_email_check CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);


-- WORKOUT TABLES
-----------------------------------------
-- Workout sessions
CREATE TABLE IF NOT EXISTS workouts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    ended_at TIMESTAMPTZ,
    title VARCHAR(255),
    workout_types TEXT[],  -- Array of workout types
    notes TEXT,
    exercises JSONB,  -- Store exercise data as JSON
    is_draft BOOLEAN DEFAULT false  -- True for drafts, false for completed workouts
);

-- Exercise library
CREATE TABLE IF NOT EXISTS exercise (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,                       -- details on how to perform the exercise
    exercise_type VARCHAR(255),
    exercise_subtype VARCHAR(255),
    primary_muscles TEXT[] NOT NULL,        -- e.g. {"Chest","Triceps"}
    secondary_muscles TEXT[],               -- e.g. {"Shoulders"}
    equipment VARCHAR(255),                         -- e.g. "Barbell","Bodyweight","Dumbbell"
    equipment_modifiers TEXT[],             -- e.g. {"Incline","Decline","Resistance Band"}
    tags TEXT[],                            -- e.g. {"Push","Compound","Strength"}
    injury_pain TEXT
);

-- Individual sets performed in a workout
CREATE TABLE IF NOT EXISTS set_entry (
    id SERIAL PRIMARY KEY,
    workout_id INT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    exercise_id INT NOT NULL REFERENCES exercise(id),
    set_number INT NOT NULL,                -- order in the workout
    set_type VARCHAR(255),
    superset_id BIGINT,
    reps INT,                               -- repetitions
    weight_kg NUMERIC(6,2),                 -- NULL for bodyweight only
    duration_s INT,                         -- for timed sets (planks, sprints)
    rpe NUMERIC(3,1),                       -- optional effort rating (1–10)
    rest_s INT,
    notes TEXT,
    injury_pain TEXT
);

--DAILY/LOGS
-------------------------------------
--the things youre tracking 
CREATE TABLE IF NOT EXISTS metrics (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    category VARCHAR(255),
    subcategory VARCHAR(255),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    parent_id INT REFERENCES metrics(id) ON DELETE SET NULL,
    is_required BOOLEAN DEFAULT false,
    data_type VARCHAR(255) NOT NULL CHECK (data_type IN ('int', 'boolean', 'text', 'scale', 'decimal', 'clock')),
    unit VARCHAR(255),
    scale_min INT,  -- only applies if data_type = 'scale'
    scale_max INT,  -- only applies if data_type = 'scale'
    modifier_label VARCHAR(255),
    modifier_value VARCHAR(255),
    notes_on BOOLEAN DEFAULT false,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now() 
);


-- metric history to be able to see when certain things were active
CREATE TABLE IF NOT EXISTS metric_history (
    id SERIAL PRIMARY KEY,
    metric_id INT NOT NULL REFERENCES metrics(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL,          -- 'activated' / 'deactivated'
    old_data_type VARCHAR(20),
    new_data_type VARCHAR(20),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS daily_logs (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    metric_id INT NOT NULL REFERENCES metrics(id) ON DELETE CASCADE,
    log_date DATE NOT NULL,
    -- one of these will be used depending on metric.data_type
    value_int INT,
    value_boolean BOOLEAN,
    value_text TEXT,
    value_decimal NUMERIC(10,2),
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(metric_id, log_date)  -- one entry per metric per day
);

--HABIT/GOAL/TRACKER
----------------------------------------
-- GOALS TABLE
CREATE TABLE IF NOT EXISTS goals (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    metric_id INT REFERENCES metrics(id) ON DELETE SET NULL, -- optional tie to a metric
    category VARCHAR(255),
    goal_text TEXT NOT NULL,
    target_value VARCHAR(255),
    progress VARCHAR(255),
    status TEXT CHECK (status IN ('active', 'paused', 'completed', 'abandoned')) DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    goal_date DATE,
    anchor_date DATE,
    frequency VARCHAR(255) DEFAULT 'once',
    completed_at DATE,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS goal_history (
    id SERIAL PRIMARY KEY,
    goal_id INT NOT NULL REFERENCES goals(id) ON DELETE CASCADE,
    change_type TEXT CHECK (change_type IN ('status', 'progress', 'note')),
    old_value TEXT,
    new_value TEXT,
    changed_at TIMESTAMPTZ DEFAULT now(),
    changed_by INT REFERENCES users(id) ON DELETE CASCADE,
    reason TEXT,
    notes TEXT
);

--Finanace

--Diet
CREATE TABLE IF NOT EXISTS foods (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(255),
    brand VARCHAR(255),
    serving_size_amount NUMERIC(8,2) NOT NULL DEFAULT 100, -- default 100
    serving_size_unit VARCHAR(255) CHECK (serving_size_unit IN ('g','ml','piece','cup','tbsp','tsp')),
    serving_unit VARCHAR(255),
    calories NUMERIC(8,2),
    protein_g NUMERIC(8,2),
    carbs_g NUMERIC(8,2),
    fat_g NUMERIC(8,2),
    fiber_g NUMERIC(8,2),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);


CREATE TABLE IF NOT EXISTS food_entry (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    food_id INT REFERENCES foods(id) ON DELETE SET NULL,
    log_date DATE NOT NULL,
    quantity NUMERIC(6,2) NOT NULL DEFAULT 1, -- multiplier of serving size
    calories NUMERIC(8,2),
    protein_g NUMERIC(8,2),
    carbs_g NUMERIC(8,2),
    fat_g NUMERIC(8,2),
    meal_type VARCHAR(255)CHECK (meal_type IN ('breakfast','lunch','dinner','snack')), 
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    
    -- Index to speed up daily queries
    UNIQUE(user_id, food_id, log_date, created_at) 
);

CREATE SEQUENCE IF NOT EXISTS superset_seq START 1;
