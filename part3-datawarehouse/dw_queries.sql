-- ============================================================================
-- Q1: Total sales revenue by product category for each month
-- ============================================================================

SELECT 
    dd.year,
    dd.month,
    dd.month_name,
    dp.category,
    COUNT(DISTINCT fs.transaction_id) AS transaction_count,
    SUM(fs.units_sold) AS total_units_sold,
    SUM(fs.total_revenue) AS total_revenue,
    ROUND(AVG(fs.total_revenue), 2) AS avg_transaction_value
FROM fact_sales fs
JOIN dim_date dd ON fs.date_id = dd.date_id
JOIN dim_product dp ON fs.product_id = dp.product_id
GROUP BY dd.year, dd.month, dd.month_name, dp.category
ORDER BY dd.year, dd.month, dp.category;

-- ============================================================================
-- Q2: Top 2 performing stores by total revenue
-- ============================================================================

SELECT 
    ds.store_name,
    ds.store_city,
    COUNT(DISTINCT fs.transaction_id) AS total_transactions,
    SUM(fs.units_sold) AS total_units_sold,
    SUM(fs.total_revenue) AS total_revenue,
    ROUND(AVG(fs.total_revenue), 2) AS avg_transaction_value
FROM fact_sales fs
JOIN dim_store ds ON fs.store_id = ds.store_id
GROUP BY ds.store_id, ds.store_name, ds.store_city
ORDER BY total_revenue DESC
LIMIT 2;

-- ============================================================================
-- Q3: Month-over-month sales trend across all stores
-- ============================================================================

WITH monthly_sales AS (
    SELECT 
        dd.year,
        dd.month,
        dd.month_name,
        SUM(fs.total_revenue) AS monthly_revenue,
        COUNT(DISTINCT fs.transaction_id) AS transaction_count
    FROM fact_sales fs
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY dd.year, dd.month, dd.month_name
),
sales_with_previous AS (
    SELECT 
        year,
        month,
        month_name,
        monthly_revenue,
        transaction_count,
        LAG(monthly_revenue) OVER (ORDER BY year, month) AS previous_month_revenue,
        LAG(month_name) OVER (ORDER BY year, month) AS previous_month_name
    FROM monthly_sales
)
SELECT 
    year,
    month,
    month_name,
    monthly_revenue,
    transaction_count,
    previous_month_name,
    previous_month_revenue,
    CASE 
        WHEN previous_month_revenue IS NULL THEN NULL
        ELSE ROUND(monthly_revenue - previous_month_revenue, 2)
    END AS revenue_change,
    CASE 
        WHEN previous_month_revenue IS NULL OR previous_month_revenue = 0 THEN NULL
        ELSE ROUND(((monthly_revenue - previous_month_revenue) / previous_month_revenue) * 100, 2)
    END AS percent_change
FROM sales_with_previous
ORDER BY year, month;