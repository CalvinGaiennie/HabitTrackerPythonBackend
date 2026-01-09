-- Migration: Add discount codes tables
-- Created: 2025-01-XX
-- Description: Adds discount_codes and discount_code_redemptions tables for free month promotions

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

-- Create discount_codes table if it doesn't exist
CREATE TABLE IF NOT EXISTS discount_codes (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    duration_days INTEGER NOT NULL DEFAULT 30,
    max_uses INTEGER,
    current_uses INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    expires_at TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index on code for faster lookups
CREATE INDEX IF NOT EXISTS idx_discount_codes_code ON discount_codes(code);

-- Create discount_code_redemptions table if it doesn't exist
CREATE TABLE IF NOT EXISTS discount_code_redemptions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    discount_code_id INTEGER NOT NULL,
    starts_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraints if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'discount_code_redemptions_user_id_fkey'
    ) THEN
        ALTER TABLE discount_code_redemptions 
        ADD CONSTRAINT discount_code_redemptions_user_id_fkey 
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'discount_code_redemptions_discount_code_id_fkey'
    ) THEN
        ALTER TABLE discount_code_redemptions 
        ADD CONSTRAINT discount_code_redemptions_discount_code_id_fkey 
        FOREIGN KEY (discount_code_id) REFERENCES discount_codes(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_discount_code_redemptions_user_id ON discount_code_redemptions(user_id);
CREATE INDEX IF NOT EXISTS idx_discount_code_redemptions_discount_code_id ON discount_code_redemptions(discount_code_id);
CREATE INDEX IF NOT EXISTS idx_discount_code_redemptions_expires_at ON discount_code_redemptions(expires_at);
CREATE INDEX IF NOT EXISTS idx_discount_code_redemptions_is_active ON discount_code_redemptions(is_active);
