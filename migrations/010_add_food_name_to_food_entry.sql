-- Migration: Add food_name column to food_entry table
-- Date: 2025-01-XX
-- Description: Adds food_name column to food_entry table to preserve food name even when food is deleted

DO $$
BEGIN
    -- Check if food_entry table exists
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'food_entry') THEN
        -- Add food_name column if it doesn't exist
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'food_entry' 
            AND column_name = 'food_name'
        ) THEN
            -- Add column as nullable first
            ALTER TABLE food_entry ADD COLUMN food_name TEXT;
            
            -- Populate food_name from foods table for existing entries
            UPDATE food_entry fe
            SET food_name = f.name
            FROM foods f
            WHERE fe.food_id = f.id AND fe.food_name IS NULL;
            
            -- Set default for any remaining NULL values (in case food_id is NULL)
            UPDATE food_entry SET food_name = '' WHERE food_name IS NULL;
            
            -- Now make it NOT NULL
            ALTER TABLE food_entry ALTER COLUMN food_name SET NOT NULL;
            ALTER TABLE food_entry ALTER COLUMN food_name SET DEFAULT '';
            
            RAISE NOTICE 'Successfully added food_name column to food_entry table';
        ELSE
            RAISE NOTICE 'food_name column already exists in food_entry table';
        END IF;
    ELSE
        RAISE NOTICE 'food_entry table does not exist - run initial schema first';
    END IF;
END $$;
