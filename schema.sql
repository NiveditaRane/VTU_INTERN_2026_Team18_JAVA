-- ============================================================
-- ServiceMate Database Schema
-- Chiranjeevi's Part: Users & Service Providers Tables
-- Sprint 1 | March 9 – March 13
-- ============================================================

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS servicemate_db;
USE servicemate_db;

-- ============================================================
-- TABLE 1: users
-- Stores all registered users (Customers, Service Providers, Admins)
-- ============================================================

CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,     -- Unique ID for each user
    full_name     VARCHAR(100)  NOT NULL,              -- User's full name
    email         VARCHAR(150)  NOT NULL UNIQUE,       -- Must be unique across all users
    password_hash VARCHAR(255)  NOT NULL,              -- Hashed password (never store plain text)
    phone_number  VARCHAR(15)   NOT NULL,              -- Contact number
    role          ENUM('CUSTOMER', 'PROVIDER', 'ADMIN') NOT NULL DEFAULT 'CUSTOMER', -- Role-based access
    is_active     BOOLEAN       NOT NULL DEFAULT TRUE, -- Soft delete / account status
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE 2: service_providers
-- Stores extra profile info for users who are Service Providers
-- Linked to users table via user_id (Foreign Key)
-- ============================================================

CREATE TABLE service_providers (
    provider_id       INT AUTO_INCREMENT PRIMARY KEY,   -- Unique ID for each provider profile
    user_id           INT          NOT NULL UNIQUE,     -- FK → users.user_id (one-to-one)
    business_name     VARCHAR(150) NOT NULL,            -- Business or professional name
    service_category  VARCHAR(100) NOT NULL,            -- E.g. Electrician, Plumber, Cleaner
    experience_years  INT          NOT NULL DEFAULT 0,  -- Years of professional experience
    location          VARCHAR(200) NOT NULL,            -- Area/city they serve
    bio               TEXT,                             -- Short description about the provider
    rating            DECIMAL(3,2) NOT NULL DEFAULT 0.00, -- Average rating (0.00 – 5.00)
    is_available      BOOLEAN      NOT NULL DEFAULT TRUE,  -- Availability toggle
    created_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Foreign Key: links provider profile back to the user account
    CONSTRAINT fk_provider_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE   -- If user is deleted, provider profile is also removed
        ON UPDATE CASCADE
);

-- ============================================================
-- INDEXES (for faster query performance)
-- ============================================================

CREATE INDEX idx_users_email    ON users(email);
CREATE INDEX idx_users_role     ON users(role);
CREATE INDEX idx_provider_category ON service_providers(service_category);
CREATE INDEX idx_provider_location  ON service_providers(location);

-- ============================================================
-- SAMPLE TEST DATA
-- ============================================================

-- Insert a Customer
INSERT INTO users (full_name, email, password_hash, phone_number, role)
VALUES ('Ravi Kumar', 'ravi@example.com', 'hashed_password_1', '9876543210', 'CUSTOMER');

-- Insert a Service Provider (user account first)
INSERT INTO users (full_name, email, password_hash, phone_number, role)
VALUES ('Arjun Sharma', 'arjun@example.com', 'hashed_password_2', '9123456780', 'PROVIDER');

-- Then insert their provider profile (user_id = 2 from above)
INSERT INTO service_providers (user_id, business_name, service_category, experience_years, location, bio)
VALUES (2, 'Arjun Electricals', 'Electrician', 5, 'Hyderabad', 'Licensed electrician with 5 years of residential experience.');

-- Insert an Admin
INSERT INTO users (full_name, email, password_hash, phone_number, role)
VALUES ('Admin User', 'admin@servicemate.com', 'hashed_password_admin', '9000000000', 'ADMIN');
