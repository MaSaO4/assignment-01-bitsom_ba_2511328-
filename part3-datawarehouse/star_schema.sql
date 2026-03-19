-- ============================================================================
-- PART 3: DATA WAREHOUSE - STAR SCHEMA DESIGN
-- ============================================================================
-- This script creates a star schema for retail transaction analytics
-- with cleaned and standardized data from retail_transactions.csv
-- ============================================================================

-- Drop existing tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;

-- ============================================================================
-- DIMENSION TABLE 1: dim_date
-- ============================================================================
-- Date dimension with hierarchical time attributes for temporal analysis
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    year INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    day_of_month INT NOT NULL
);

-- ============================================================================
-- DIMENSION TABLE 2: dim_store
-- ============================================================================
-- Store dimension with location information
CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(50) NOT NULL UNIQUE,
    store_city VARCHAR(50) NOT NULL
);

-- ============================================================================
-- DIMENSION TABLE 3: dim_product
-- ============================================================================
-- Product dimension with category and pricing information
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- ============================================================================
-- FACT TABLE: fact_sales
-- ============================================================================
-- Central fact table containing sales transactions with foreign keys to dimensions
CREATE TABLE fact_sales (
    sale_id INT PRIMARY KEY,
    transaction_id VARCHAR(20) NOT NULL UNIQUE,
    date_id INT NOT NULL,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    units_sold INT NOT NULL,
    total_revenue DECIMAL(12, 2) NOT NULL,
    
    -- Foreign key constraints
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- ============================================================================
-- DATA LOADING: dim_date
-- ============================================================================
-- Populate date dimension with all months of 2023 (representative dates)
INSERT INTO dim_date (date_id, full_date, year, month, month_name, quarter, day_of_week, day_of_month) VALUES
(20230101, '2023-01-01', 2023, 1, 'January', 1, 'Sunday', 1),
(20230115, '2023-01-15', 2023, 1, 'January', 1, 'Sunday', 15),
(20230205, '2023-02-05', 2023, 2, 'February', 1, 'Sunday', 5),
(20230220, '2023-02-20', 2023, 2, 'February', 1, 'Monday', 20),
(20230331, '2023-03-31', 2023, 3, 'March', 1, 'Friday', 31),
(20230414, '2023-04-14', 2023, 4, 'April', 2, 'Friday', 14),
(20230521, '2023-05-21', 2023, 5, 'May', 2, 'Sunday', 21),
(20230604, '2023-06-04', 2023, 6, 'June', 2, 'Sunday', 4),
(20230722, '2023-07-22', 2023, 7, 'July', 3, 'Saturday', 22),
(20230809, '2023-08-09', 2023, 8, 'August', 3, 'Wednesday', 9),
(20230829, '2023-08-29', 2023, 8, 'August', 3, 'Tuesday', 29),
(20231026, '2023-10-26', 2023, 10, 'October', 4, 'Thursday', 26),
(20231118, '2023-11-18', 2023, 11, 'November', 4, 'Saturday', 18),
(20231208, '2023-12-08', 2023, 12, 'December', 4, 'Friday', 8),
(20231212, '2023-12-12', 2023, 12, 'December', 4, 'Tuesday', 12);

-- ============================================================================
-- DATA LOADING: dim_store
-- ============================================================================
-- Populate store dimension with all retail locations
-- ETL Note: Missing store_city values were resolved by deriving from store_name
INSERT INTO dim_store (store_id, store_name, store_city) VALUES
(1, 'Chennai Anna', 'Chennai'),
(2, 'Delhi South', 'Delhi'),
(3, 'Bangalore MG', 'Bangalore'),
(4, 'Pune FC Road', 'Pune'),
(5, 'Mumbai Central', 'Mumbai');

-- ============================================================================
-- DATA LOADING: dim_product
-- ============================================================================
-- Populate product dimension with unique products
-- ETL Note: Category names standardized to title case (Electronics, Clothing, Grocery)
INSERT INTO dim_product (product_id, product_name, category, unit_price) VALUES
(1, 'Speaker', 'Electronics', 49262.78),
(2, 'Tablet', 'Electronics', 23226.12),
(3, 'Phone', 'Electronics', 48703.39),
(4, 'Smartwatch', 'Electronics', 58851.01),
(5, 'Laptop', 'Electronics', 42343.15),
(6, 'Headphones', 'Electronics', 39854.96),
(7, 'Atta 10kg', 'Grocery', 52464.00),
(8, 'Biscuits', 'Grocery', 27469.99),
(9, 'Milk 1L', 'Grocery', 43374.39),
(10, 'Pulses 1kg', 'Grocery', 31604.47),
(11, 'Rice 5kg', 'Grocery', 52195.05),
(12, 'Oil 1L', 'Grocery', 26474.34),
(13, 'Jeans', 'Clothing', 2317.47),
(14, 'Jacket', 'Clothing', 30187.24),
(15, 'Saree', 'Clothing', 35451.81),
(16, 'T-Shirt', 'Clothing', 29770.19);

-- ============================================================================
-- DATA LOADING: fact_sales
-- ============================================================================
-- Populate fact table with cleaned sample transactions
-- ETL Notes:
-- 1. Dates standardized to YYYY-MM-DD format
-- 2. Category casing standardized (electronics -> Electronics, Groceries -> Grocery)
-- 3. Missing store_city values resolved by store_name lookup
-- 4. total_revenue calculated as units_sold * unit_price

INSERT INTO fact_sales (sale_id, transaction_id, date_id, store_id, product_id, customer_id, units_sold, total_revenue) VALUES
-- Transaction 1: Original date format "29/08/2023" -> standardized to 2023-08-29
(1, 'TXN5000', 20230829, 1, 1, 'CUST045', 3, 147788.34),

-- Transaction 2: Original date format "12-12-2023" -> standardized, category "Electronics" (already correct)
(2, 'TXN5001', 20231212, 1, 2, 'CUST021', 11, 255487.32),

-- Transaction 3: Original date format "2023-02-05" (already standard), category "Electronics"
(3, 'TXN5002', 20230205, 1, 3, 'CUST019', 20, 974067.80),

-- Transaction 4: Original date "20-02-2023" -> standardized, category "Electronics"
(4, 'TXN5003', 20230220, 2, 2, 'CUST007', 14, 325165.68),

-- Transaction 5: Original date "2023-01-15", category "electronics" -> "Electronics"
(5, 'TXN5004', 20230115, 1, 4, 'CUST004', 10, 588510.10),

-- Transaction 6: Original date "2023-08-09", category "Grocery" (already correct)
(6, 'TXN5005', 20230809, 3, 7, 'CUST027', 12, 629568.00),

-- Transaction 7: Original date "2023-03-31", category "electronics" -> "Electronics"
(7, 'TXN5006', 20230331, 4, 4, 'CUST025', 6, 353106.06),

-- Transaction 8: Original date "2023-10-26", category "Clothing" (already correct)
(8, 'TXN5007', 20231026, 4, 13, 'CUST041', 16, 37079.52),

-- Transaction 9: Original date "2023-12-08", category "Groceries" -> "Grocery"
(9, 'TXN5008', 20231208, 3, 8, 'CUST030', 9, 247229.91),

-- Transaction 10: Original date "2023-06-04", category "Clothing" (already correct)
(10, 'TXN5010', 20230604, 1, 14, 'CUST031', 15, 452808.60),

-- Transaction 11: Original date "2023-05-21", category "Electronics"
(11, 'TXN5012', 20230521, 3, 5, 'CUST044', 13, 550460.95),

-- Transaction 12: Original date "2023-11-18", category "Clothing"
(12, 'TXN5014', 20231118, 2, 14, 'CUST042', 5, 150936.20),

-- Transaction 13: Original date "2023-07-22", category "Grocery" (standardized from "Grocery")
(13, 'TXN5019', 20230722, 1, 7, 'CUST008', 3, 157392.00),

-- Transaction 14: Original date "2023-04-14", category "Electronics"
(14, 'TXN5106', 20230414, 1, 3, 'CUST003', 10, 487033.90),

-- Transaction 15: Original date "2023-01-01" (derived), category "electronics" -> "Electronics"
(15, 'TXN5031', 20230101, 3, 1, 'CUST010', 20, 985255.60);