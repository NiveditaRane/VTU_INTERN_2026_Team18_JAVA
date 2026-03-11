USE servicemate;

-- Services Table
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2),
    provider_id INT
);

-- Bookings Table
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    service_id INT,
    booking_date DATE,
    status VARCHAR(50)
);

-- Foreign Key Relationship
ALTER TABLE bookings
ADD CONSTRAINT fk_service
FOREIGN KEY (service_id)
REFERENCES services(service_id);
