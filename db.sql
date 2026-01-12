-- Database Schema for Motorcycle Shop Mobile App
-- Compatible with MySQL, PostgreSQL, and SQLite

-- 1. Users Table
-- Stores customer and admin information
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT, -- Use SERIAL for PostgreSQL or INTEGER PRIMARY KEY AUTOINCREMENT for SQLite
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Store hashed passwords, never plain text
    phone_number VARCHAR(20),
    address TEXT,
    role VARCHAR(20) DEFAULT 'customer', -- 'customer' or 'admin'
    profile_image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
-- Categorizes products (e.g., Sport Bikes, Cruisers, Helmets, Parts)
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    image_url VARCHAR(255)
);

-- 3. Products Table
-- Stores both Motorcycles and Accessories/Parts
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    image_url VARCHAR(255),
    
    -- Specific fields for Motorcycles (can be null for parts)
    brand VARCHAR(50),
    model_year INT,
    engine_cc INT,
    color VARCHAR(30),
    condition_status VARCHAR(20) DEFAULT 'new', -- 'new', 'used'
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

-- 4. Orders Table
-- Tracks purchase headers
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'confirmed', 'shipped', 'delivered', 'cancelled'
    shipping_address TEXT NOT NULL,
    payment_method VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 5. OrderItems Table
-- Tracks individual items within an order
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL, -- Price at the time of purchase
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 6. Services Table
-- List of services offered (e.g., Oil Change, Tire Replacement)
CREATE TABLE Services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    estimated_duration_minutes INT,
    base_price DECIMAL(10, 2)
);

-- 7. Appointments Table
-- For booking maintenance or test rides
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    service_id INT, -- Nullable if it's a generic checkup or test ride
    vehicle_details VARCHAR(100), -- E.g., "2020 Yamaha R1"
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'scheduled', -- 'scheduled', 'completed', 'cancelled'
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Services(service_id) ON DELETE SET NULL
);

-- 8. Reviews Table
-- user reviews for products
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Indexes for performance optimization on mobile
CREATE INDEX idx_products_category ON Products(category_id);
CREATE INDEX idx_orders_user ON Orders(user_id);
CREATE INDEX idx_appointments_date ON Appointments(appointment_date);

-- =============================================
-- SAMPLE DATA INSERTION (For Testing)
-- =============================================

INSERT INTO Categories (name, description) VALUES 
('Sport Bikes', 'High performance motorcycles'),
('Cruisers', 'Comfortable riding position'),
('Helmets', 'Safety gear'),
('Maintenance', 'Oils and fluids');

INSERT INTO Products (category_id, name, price, stock_quantity, brand, model_year, engine_cc, color) VALUES 
(1, 'Yamaha YZF-R1', 17599.00, 5, 'Yamaha', 2024, 998, 'Blue'),
(2, 'Harley-Davidson Iron 883', 11249.00, 3, 'Harley-Davidson', 2023, 883, 'Black'),
(3, 'Shoei RF-1400 Helmet', 579.00, 20, 'Shoei', NULL, NULL, 'Matte Black');

INSERT INTO Services (name, base_price, estimated_duration_minutes) VALUES 
('Oil Change', 49.99, 30),
('Full Service Checkup', 199.99, 120),
('Tire Replacement', 89.99, 60);

INSERT INTO Users (full_name, email, password_hash, phone_number, role) VALUES 
('Admin User', 'admin@shop.com', 'hashed_secret_password', '555-0101', 'admin'),
('John Doe', 'john@example.com', 'hashed_user_password', '555-0102', 'customer');