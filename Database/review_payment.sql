USE servicemate;

-- 1. Reviews Table
-- Links a customer's feedback to a service provider
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,  -- The user who is a 'customer'
    provider_id INT NOT NULL,  -- The user who is a 'provider'
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Constraints: Foreign Keys
    -- If a user is deleted, their reviews are removed (ON DELETE CASCADE)
    CONSTRAINT fk_review_customer FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_provider FOREIGN KEY (provider_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 2. Payments Table
-- Tracks financial transactions between users
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    provider_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL, -- Supports values like 999.50
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    transaction_id VARCHAR(100) UNIQUE, -- Unique ID from payment gateway
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Constraints: Foreign Keys
    CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_payment_provider FOREIGN KEY (provider_id) REFERENCES users(user_id) ON DELETE CASCADE
);