-- ============================================================================
-- Database Normalization: Third Normal Form (3NF) Schema Design
-- ============================================================================
-- This schema normalizes the orders_flat.csv file into 5 related tables
-- to eliminate insert, update, and delete anomalies.
-- ============================================================================

-- Drop tables if they exist (for clean re-execution)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales_representatives;

-- ============================================================================
-- Table 1: customers
-- ============================================================================
-- Stores unique customer information
-- Primary Key: customer_id
-- ============================================================================

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    customer_city VARCHAR(50) NOT NULL
);

-- Insert customer data (at least 5 rows)
INSERT INTO customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001', 'Rohan Mehta', 'rohan@gmail.com', 'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com', 'Delhi'),
('C003', 'Amit Verma', 'amit@gmail.com', 'Bangalore'),
('C004', 'Sneha Iyer', 'sneha@gmail.com', 'Chennai'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta', 'neha@gmail.com', 'Delhi'),
('C007', 'Arjun Nair', 'arjun@gmail.com', 'Bangalore'),
('C008', 'Kavya Rao', 'kavya@gmail.com', 'Hyderabad');

-- ============================================================================
-- Table 2: products
-- ============================================================================
-- Stores unique product information
-- Primary Key: product_id
-- ============================================================================

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- Insert product data (at least 5 rows)
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
('P001', 'Laptop', 'Electronics', 55000.00),
('P002', 'Mouse', 'Electronics', 800.00),
('P003', 'Desk Chair', 'Furniture', 8500.00),
('P004', 'Notebook', 'Stationery', 120.00),
('P005', 'Headphones', 'Electronics', 3200.00),
('P006', 'Standing Desk', 'Furniture', 22000.00),
('P007', 'Pen Set', 'Stationery', 250.00),
('P008', 'Webcam', 'Electronics', 2100.00);

-- ============================================================================
-- Table 3: sales_representatives
-- ============================================================================
-- Stores unique sales representative information
-- Primary Key: sales_rep_id
-- ============================================================================

CREATE TABLE sales_representatives (
    sales_rep_id VARCHAR(10) PRIMARY KEY,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) NOT NULL,
    office_address VARCHAR(200) NOT NULL
);

-- Insert sales representative data (at least 5 rows)
INSERT INTO sales_representatives (sales_rep_id, sales_rep_name, sales_rep_email, office_address) VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai', 'anita@corp.com', 'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar', 'ravi@corp.com', 'South Zone, MG Road, Bangalore - 560001');

-- ============================================================================
-- Table 4: orders
-- ============================================================================
-- Stores order header information
-- Primary Key: order_id
-- Foreign Keys: customer_id (references customers), sales_rep_id (references sales_representatives)
-- ============================================================================

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (sales_rep_id) REFERENCES sales_representatives(sales_rep_id)
);

-- Insert order data (at least 5 rows)
INSERT INTO orders (order_id, customer_id, sales_rep_id, order_date) VALUES
('ORD1027', 'C002', 'SR02', '2023-11-02'),
('ORD1114', 'C001', 'SR01', '2023-08-06'),
('ORD1153', 'C006', 'SR01', '2023-02-14'),
('ORD1002', 'C002', 'SR02', '2023-01-17'),
('ORD1118', 'C006', 'SR02', '2023-11-10'),
('ORD1132', 'C003', 'SR02', '2023-03-07'),
('ORD1037', 'C002', 'SR03', '2023-03-06'),
('ORD1075', 'C005', 'SR03', '2023-04-18'),
('ORD1083', 'C006', 'SR01', '2023-07-03'),
('ORD1091', 'C001', 'SR01', '2023-07-24'),
('ORD1162', 'C006', 'SR03', '2023-09-29'),
('ORD1185', 'C003', 'SR03', '2023-06-15'),
('ORD1076', 'C004', 'SR03', '2023-05-16'),
('ORD1133', 'C001', 'SR03', '2023-10-16'),
('ORD1061', 'C006', 'SR01', '2023-10-27'),
('ORD1098', 'C007', 'SR03', '2023-10-03'),
('ORD1131', 'C008', 'SR02', '2023-06-22'),
('ORD1137', 'C005', 'SR02', '2023-05-10'),
('ORD1022', 'C005', 'SR01', '2023-10-15'),
('ORD1054', 'C002', 'SR03', '2023-10-04');

-- ============================================================================
-- Table 5: order_items
-- ============================================================================
-- Stores individual line items for each order (many-to-many relationship between orders and products)
-- Primary Key: order_item_id
-- Foreign Keys: order_id (references orders), product_id (references products)
-- ============================================================================

CREATE TABLE order_items (
    order_item_id VARCHAR(15) PRIMARY KEY,
    order_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert order items data (at least 5 rows)
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES
('OI001', 'ORD1027', 'P004', 4),
('OI002', 'ORD1114', 'P007', 2),
('OI003', 'ORD1153', 'P007', 3),
('OI004', 'ORD1002', 'P005', 1),
('OI005', 'ORD1118', 'P007', 5),
('OI006', 'ORD1132', 'P007', 5),
('OI007', 'ORD1037', 'P007', 2),
('OI008', 'ORD1075', 'P003', 3),
('OI009', 'ORD1083', 'P007', 2),
('OI010', 'ORD1091', 'P006', 3),
('OI011', 'ORD1162', 'P004', 3),
('OI012', 'ORD1185', 'P008', 1),
('OI013', 'ORD1076', 'P006', 5),
('OI014', 'ORD1133', 'P004', 1),
('OI015', 'ORD1061', 'P001', 4),
('OI016', 'ORD1098', 'P001', 2),
('OI017', 'ORD1131', 'P001', 4),
('OI018', 'ORD1137', 'P007', 1),
('OI019', 'ORD1022', 'P002', 5),
('OI020', 'ORD1054', 'P001', 1);