-- Create database
CREATE DATABASE IF NOT EXISTS expense_tracker;
USE expense_tracker;

-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table with pre-defined categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    icon VARCHAR(50) NOT NULL,
    color VARCHAR(20) NOT NULL,
    is_default BOOLEAN DEFAULT TRUE
);

-- Expenses table
CREATE TABLE expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description VARCHAR(255),
    expense_date DATE NOT NULL,
    payment_method ENUM('CASH', 'CARD', 'UPI') DEFAULT 'CASH',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- Budgets table
CREATE TABLE budgets (
    budget_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    year INT NOT NULL,
    budget_amount DECIMAL(10,2) NOT NULL,
    alert_threshold INT DEFAULT 80,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_month_year (user_id, month, year),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert default categories with icons and colors
INSERT INTO categories (category_name, icon, color, is_default) VALUES
('Food & Dining', 'fas fa-utensils', 'bg-red-500', TRUE),
('Transportation', 'fas fa-car', 'bg-blue-500', TRUE),
('Shopping', 'fas fa-shopping-bag', 'bg-purple-500', TRUE),
('Bills & Utilities', 'fas fa-file-invoice', 'bg-green-500', TRUE),
('Entertainment', 'fas fa-film', 'bg-yellow-500', TRUE),
('Healthcare', 'fas fa-heartbeat', 'bg-pink-500', TRUE),
('Education', 'fas fa-graduation-cap', 'bg-indigo-500', TRUE),
('Travel', 'fas fa-plane', 'bg-teal-500', TRUE),
('Gifts & Donations', 'fas fa-gift', 'bg-orange-500', TRUE),
('Other', 'fas fa-ellipsis-h', 'bg-gray-500', TRUE);

-- Create indexes for better performance
CREATE INDEX idx_expenses_user_date ON expenses(user_id, expense_date);
CREATE INDEX idx_expenses_date ON expenses(expense_date);
CREATE INDEX idx_budgets_user_month_year ON budgets(user_id, month, year);

-- Sample data for testing (optional)
INSERT INTO users (username, email, password_hash, full_name) VALUES 
('testuser', 'test@example.com', '$2a$10$examplehashedpassword', 'Test User');

INSERT INTO budgets (user_id, month, year, budget_amount) VALUES 
(1, MONTH(CURRENT_DATE), YEAR(CURRENT_DATE), 5000.00);

INSERT INTO expenses (user_id, category_id, amount, description, expense_date, payment_method) VALUES
(1, 1, 25.50, 'Lunch at restaurant', CURDATE(), 'CASH'),
(1, 2, 15.00, 'Bus fare', CURDATE(), 'CARD'),
(1, 3, 45.99, 'Grocery shopping', DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'UPI');