/* ============================================================
   DATABASE & METADATA EXPLORATION
   ============================================================ */

-- Check current database
SELECT DB_NAME();

-- Switch to required database
USE DataWarehouseAnalytics;

-- View column structure of Customer Dimension table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';



/* ============================================================
   STEP 1: DIMENSION EXPLORATION
   ============================================================ */

-- Identify distinct countries available in customer data
SELECT DISTINCT country
FROM gold.dim_customers;
-- Countries: Germany, United States, Australia, United Kingdom, Canada, France


-- Explore product hierarchy (Category → Subcategory → Product)
SELECT DISTINCT
       category,
       subcategory,
       product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
-- Categories: Accessories, Bikes, Clothing, Components



/* ============================================================
   STEP 2: DATE EXPLORATION
   Purpose: Identify overall time coverage of sales data
   ============================================================ */

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_year
FROM gold.fact_sales;
-- Insight: Dataset contains 4 years of sales data


-- Determine oldest and youngest customers
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), CURRENT_DATE) AS oldest_customer_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), CURRENT_DATE) AS youngest_customer_age
FROM gold.dim_customers;



/* ============================================================
   STEP 3: MEASURE EXPLORATION (Core Business Metrics)
   High-level aggregation to understand overall performance
   ============================================================ */

-- 1. Total Sales Revenue
SELECT
    SUM(quantity * price) AS total_sales
FROM gold.fact_sales;


-- 2. Total Quantity Sold
SELECT
    SUM(quantity) AS total_items_sold
FROM gold.fact_sales;


-- 3. Average Selling Price
SELECT
    AVG(price) AS average_selling_price
FROM gold.fact_sales;


-- 4. Total Orders (Raw vs Distinct)
SELECT
    COUNT(order_number) AS total_order_records,
    COUNT(DISTINCT order_number) AS total_unique_orders
FROM gold.fact_sales;


-- 5. Total Products
SELECT
    COUNT(product_key) AS total_product_records,
    COUNT(DISTINCT product_key) AS total_unique_products
FROM gold.dim_products;


-- 6. Total Customers
SELECT
    COUNT(customer_key) AS total_customer_records,
    COUNT(DISTINCT customer_key) AS total_unique_customers
FROM gold.dim_customers;


-- 7. Customers Who Placed Orders
SELECT
    COUNT(DISTINCT customer_key) AS customers_with_orders
FROM gold.fact_sales;



/* ============================================================
   CONSOLIDATED KPI REPORT
   Combines all major metrics into a single result set
   ============================================================ */

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total No. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total No. Products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total No. Customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers;



/* ============================================================
   STEP 4: MAGNITUDE ANALYSIS
   Comparing performance across different dimensions
   ============================================================ */

-- Total customers by country
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;


-- Customers by gender
SELECT
    gender,
    COUNT(customer_key) AS customers_per_gender
FROM gold.dim_customers
GROUP BY gender
ORDER BY customers_per_gender DESC;


-- Total products by category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;


-- Average product cost by category
SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;


-- Revenue generated per category
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Revenue generated per customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;


-- Distribution of sold quantity across countries
SELECT
    c.country,
    SUM(f.quantity) AS total_items_sold
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_items_sold DESC;



/* ============================================================
   STEP 5: RANKING ANALYSIS
   Identifying Top & Bottom Performers
   ============================================================ */

-- Top 5 revenue-generating products
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;


-- Alternative ranking using ROW_NUMBER()
SELECT *
FROM (
        SELECT
            p.product_name,
            SUM(f.sales_amount) AS total_revenue,
            ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS revenue_rank
        FROM gold.dim_products p
        LEFT JOIN gold.fact_sales f
            ON p.product_key = f.product_key
        GROUP BY p.product_name
     ) AS ranked_products
WHERE revenue_rank <= 5;


-- Bottom 5 worst-performing products
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;



/* ============================================================
   CUSTOMER PERFORMANCE ANALYSIS
   ============================================================ */

-- Top 10 customers by revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;


-- 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;