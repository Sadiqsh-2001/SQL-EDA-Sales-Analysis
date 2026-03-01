/* =====================================================================
   PROJECT: SALES DATA ANALYTICS
   AUTHOR : Sadique Shoaib
   ROLE   : Data Analytics Portfolio Project

   DESCRIPTION:
   This script performs structured exploration and business analysis
   on a dimensional data warehouse model using SQL Server.

   OBJECTIVES:
   - Explore metadata & schema structure
   - Analyze dimensions (customers, products,etc)
   - Evaluate date coverage
   - Calculate core KPIs
   - Perform magnitude analysis
   - Apply ranking and performance analysis
   - Implement advanced window functions

   DATABASE: datawarehouseanalytics
   SCHEMA  : gold
   ===================================================================== */


/* =====================================================================
   SECTION 1: DATABASE & METADATA EXPLORATION
   ===================================================================== */

-- check current database
select db_name();

-- switch to required database
use datawarehouseanalytics;

-- inspect customer dimension structure
select *
from information_schema.columns
where table_name = 'dim_customers';



/* =====================================================================
   SECTION 2: DIMENSION EXPLORATION
   ===================================================================== */

-- distinct countries in customer dataset
select distinct country
from gold.dim_customers;

-- product hierarchy analysis (category → subcategory → product)
select distinct
       category,
       subcategory,
       product_name
from gold.dim_products
order by category, subcategory, product_name;



/* =====================================================================
   SECTION 3: DATE RANGE ANALYSIS
   ===================================================================== */

-- overall sales coverage period
select
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    datediff(year, min(order_date), max(order_date)) as order_range_year
from gold.fact_sales;

-- oldest and youngest customers
select
    min(birthdate) as oldest_birthdate,
    datediff(year, min(birthdate), current_date) as oldest_customer_age,
    max(birthdate) as youngest_birthdate,
    datediff(year, max(birthdate), current_date) as youngest_customer_age
from gold.dim_customers;



/* =====================================================================
   SECTION 4: CORE BUSINESS KPIs
   ===================================================================== */

-- total revenue
select sum(quantity * price) as total_sales
from gold.fact_sales;

-- total quantity sold
select sum(quantity) as total_items_sold
from gold.fact_sales;

-- average selling price
select avg(price) as average_selling_price
from gold.fact_sales;

-- total orders (raw vs distinct)
select
    count(order_number) as total_order_records,
    count(distinct order_number) as total_unique_orders
from gold.fact_sales;

-- total products
select
    count(product_key) as total_product_records,
    count(distinct product_key) as total_unique_products
from gold.dim_products;

-- total customers
select
    count(customer_key) as total_customer_records,
    count(distinct customer_key) as total_unique_customers
from gold.dim_customers;

-- customers who placed orders
select count(distinct customer_key) as customers_with_orders
from gold.fact_sales;



/* =====================================================================
   SECTION 5: CONSOLIDATED KPI REPORT
   ===================================================================== */

select 'total sales' as measure_name, sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'total quantity', sum(quantity) from gold.fact_sales
union all
select 'average price', avg(price) from gold.fact_sales
union all
select 'total no. orders', count(distinct order_number) from gold.fact_sales
union all
select 'total no. products', count(distinct product_key) from gold.dim_products
union all
select 'total no. customers', count(distinct customer_key) from gold.dim_customers;



/* =====================================================================
   SECTION 6: MAGNITUDE ANALYSIS
   ===================================================================== */

-- customers by country
select
    country,
    count(customer_key) as total_customers
from gold.dim_customers
group by country
order by total_customers desc;

-- customers by gender
select
    gender,
    count(customer_key) as customers_per_gender
from gold.dim_customers
group by gender
order by customers_per_gender desc;

-- products by category
select
    category,
    count(product_key) as total_products
from gold.dim_products
group by category
order by total_products desc;

-- average cost by category
select
    category,
    avg(cost) as avg_cost
from gold.dim_products
group by category
order by avg_cost desc;

-- revenue by category
select
    p.category,
    sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_products p
    on f.product_key = p.product_key
group by p.category
order by total_revenue desc;

-- revenue by customer
select
    c.customer_key,
    c.first_name,
    c.last_name,
    sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_customers c
    on f.customer_key = c.customer_key
group by c.customer_key, c.first_name, c.last_name
order by total_revenue desc;

-- quantity distribution by country
select
    c.country,
    sum(f.quantity) as total_items_sold
from gold.fact_sales f
left join gold.dim_customers c
    on f.customer_key = c.customer_key
group by c.country
order by total_items_sold desc;



/* =====================================================================
   SECTION 7: RANKING ANALYSIS
   ===================================================================== */

-- top 5 products by revenue
select top 5
    p.product_name,
    sum(f.sales_amount) as total_revenue
from gold.dim_products p
left join gold.fact_sales f
    on p.product_key = f.product_key
group by p.product_name
order by total_revenue desc;

-- ranking with row_number()
select *
from (
        select
            p.product_name,
            sum(f.sales_amount) as total_revenue,
            row_number() over (order by sum(f.sales_amount) desc) as revenue_rank
        from gold.dim_products p
        left join gold.fact_sales f
            on p.product_key = f.product_key
        group by p.product_name
     ) as ranked_products
where revenue_rank <= 5;

-- bottom 5 products
select top 5
    p.product_name,
    sum(f.sales_amount) as total_revenue
from gold.dim_products p
left join gold.fact_sales f
    on p.product_key = f.product_key
group by p.product_name
order by total_revenue asc;



/* =====================================================================
   SECTION 8: CUSTOMER PERFORMANCE ANALYSIS
   ===================================================================== */

-- top 10 customers by revenue
select top 10
    c.customer_key,
    c.first_name,
    c.last_name,
    sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_customers c
    on f.customer_key = c.customer_key
group by c.customer_key, c.first_name, c.last_name
order by total_revenue desc;

-- 3 customers with fewest orders
select top 3
    c.customer_key,
    c.first_name,
    c.last_name,
    count(distinct f.order_number) as total_orders
from gold.fact_sales f
left join gold.dim_customers c
    on f.customer_key = c.customer_key
group by c.customer_key, c.first_name, c.last_name
order by total_orders asc;



/* =====================================================================
   SECTION 9: ADVANCED ANALYSIS (CTEs & WINDOW FUNCTIONS)
   ===================================================================== */

-- top 2 products per country
with country_revenue as (
    select
        c.country,
        p.product_name,
        sum(f.quantity) as total_quantity
    from gold.dim_customers c
    inner join gold.fact_sales f
        on c.customer_key = f.customer_key
    inner join gold.dim_products p
        on f.product_key = p.product_key
    group by c.country, p.product_name
),
country_ranking as (
    select
        country,
        product_name,
        total_quantity,
        row_number() over (
            partition by country
            order by total_quantity desc
        ) as rn
    from country_revenue
)
select country, product_name, total_quantity
from country_ranking
where rn <= 2
order by country asc;



-- running revenue per country over time
with country_revn as (
    select
        c.country,
        year(f.order_date) as order_year,
        month(f.order_date) as order_mnth,
        sum(f.sales_amount) as total_sales
    from gold.dim_customers c
    inner join gold.fact_sales f
        on c.customer_key = f.customer_key
    group by c.country, year(f.order_date), month(f.order_date)
)
select *,
       sum(total_sales) over (
           partition by country
           order by order_year, order_mnth
           rows between unbounded preceding and current row
       ) as running_total
from country_revn;
