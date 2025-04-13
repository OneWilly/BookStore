-- Create the bookstore database if it doesn't exist
CREATE DATABASE IF NOT EXISTS bookstore;
USE bookstore;

-- Table: country
CREATE TABLE IF NOT EXISTS country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL
);

-- Table: address
CREATE TABLE IF NOT EXISTS address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Table: address_status
CREATE TABLE IF NOT EXISTS address_status (
    address_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table: customer
CREATE TABLE IF NOT EXISTS customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20)
);

-- Table: customer_address (Many-to-Many Relationship)
CREATE TABLE IF NOT EXISTS customer_address (
    customer_id INT,
    address_id INT,
    address_status_id INT DEFAULT 1,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

-- Table: publisher
CREATE TABLE IF NOT EXISTS publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) UNIQUE NOT NULL
);

-- Table: book_language
CREATE TABLE IF NOT EXISTS book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table: author
CREATE TABLE IF NOT EXISTS author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

-- Table: book
CREATE TABLE IF NOT EXISTS book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    publication_year YEAR,
    language_id INT,
    publisher_id INT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Table: book_author (Many-to-Many Relationship)
CREATE TABLE IF NOT EXISTS book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Table: shipping_method
CREATE TABLE IF NOT EXISTS shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) UNIQUE NOT NULL,
    cost DECIMAL(5, 2) NOT NULL CHECK (cost >= 0)
);

-- Table: order_status
CREATE TABLE IF NOT EXISTS order_status (
    order_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table: cust_order
CREATE TABLE IF NOT EXISTS cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shipping_address_id INT,
    billing_address_id INT,
    shipping_method_id INT,
    order_status_id INT DEFAULT 1,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (billing_address_id) REFERENCES address(address_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);

-- Table: order_line
CREATE TABLE IF NOT EXISTS order_line (
    order_line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_order DECIMAL(10, 2) NOT NULL CHECK (price_at_order >= 0),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Table: order_history
CREATE TABLE IF NOT EXISTS order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    order_status_id INT,
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);

-- Sample Data Insertion
-- Insert sample data into country
INSERT INTO country (country_name) VALUES 
('United States'), 
('Canada'), 
('United Kingdom');

-- Insert sample data into address
INSERT INTO address (street, city, region, postal_code, country_id) VALUES 
('123 Main St', 'New York', 'NY', '10001', 1),
('456 Elm St', 'Toronto', 'ON', 'M4B 1B4', 2),
('789 High St', 'London', NULL, 'SW1A 1AA', 3);

-- Insert sample data into address_status
INSERT INTO address_status (status_name) VALUES 
('Current'), 
('Old');

-- Insert sample data into customer
INSERT INTO customer (first_name, last_name, email, phone_number) VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210');

-- Insert sample data into customer_address
INSERT INTO customer_address (customer_id, address_id, address_status_id) VALUES 
(1, 1, 1), 
(2, 2, 1);

-- Insert sample data into publisher
INSERT INTO publisher (publisher_name) VALUES 
('Penguin Random House'), 
('HarperCollins'), 
('Simon & Schuster');

-- Insert sample data into book_language
INSERT INTO book_language (language_name) VALUES 
('English'), 
('French'), 
('Spanish');

-- Insert sample data into author
INSERT INTO author (first_name, last_name) VALUES 
('George', 'Orwell'), 
('J.K.', 'Rowling'), 
('Jane', 'Austen');

-- Insert sample data into book
INSERT INTO book (isbn, title, publication_year, language_id, publisher_id, price, stock_quantity) VALUES 
('9780451524935', '1984', 1949, 1, 1, 9.99, 100),
('9780439139601', 'Harry Potter and the Goblet of Fire', 2000, 1, 2, 29.99, 50),
('9780141439518', 'Pride and Prejudice', 1813, 1, 3, 14.99, 75);

-- Insert sample data into book_author
INSERT INTO book_author (book_id, author_id) VALUES 
(1, 1), 
(2, 2), 
(3, 3);

-- Insert sample data into shipping_method
INSERT INTO shipping_method (method_name, cost) VALUES 
('Standard Shipping', 5.00), 
('Express Shipping', 15.00);

-- Insert sample data into order_status
INSERT INTO order_status (status_name) VALUES 
('Pending'), 
('Shipped'), 
('Delivered');

-- Insert sample data into cust_order
INSERT INTO cust_order (customer_id, shipping_address_id, billing_address_id, shipping_method_id, order_status_id) VALUES 
(1, 1, 1, 1, 1), 
(2, 2, 2, 2, 2);

-- Insert sample data into order_line
INSERT INTO order_line (order_id, book_id, quantity, price_at_order) VALUES 
(1, 1, 2, 19.98), 
(2, 2, 1, 29.99);

-- Insert sample data into order_history
INSERT INTO order_history (order_id, order_status_id) VALUES 
(1, 1), 
(2, 2);

-- User Setup and Permissions
-- Create a read-only user
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'readonly_password';
GRANT SELECT ON bookstore.* TO 'readonly_user'@'localhost';

-- Create a data entry user
CREATE USER 'data_entry_user'@'localhost' IDENTIFIED BY 'data_entry_password';
GRANT SELECT, INSERT, UPDATE ON bookstore.* TO 'data_entry_user'@'localhost';

-- Create an admin user
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_password';
GRANT ALL PRIVILEGES ON bookstore.* TO 'admin_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;