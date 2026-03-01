Sales Data Analytics Exploration (SQL Server)
Project Overview

This project demonstrates structured data exploration and business analysis using SQL on a dimensional data warehouse model. The objective is to analyze customer behavior, product performance, revenue trends, and key business metrics using advanced SQL techniques.

The project is designed to showcase strong SQL fundamentals, analytical thinking, and real-world data analysis skills relevant to a Data Analyst role.

Database Details

Database Name: datawarehouseanalytics
Schema Used: gold
Model Type: Star Schema (Fact + Dimension tables)
Tables Used
gold.fact_sales
gold.dim_customers
gold.dim_products

Business Objectives
The analysis focuses on:
Exploring metadata and understanding schema structure
Analyzing customer and product dimensions
Evaluating time coverage of sales data
Calculating core KPIs
Performing magnitude analysis across business dimensions
Identifying top and bottom performers

Applying advanced SQL techniques (CTEs & Window Functions)
Key SQL Concepts Demonstrated

This project highlights the following SQL skills:

Aggregate Functions (SUM, COUNT, AVG, MIN, MAX)
GROUP BY and ORDER BY
INNER JOIN and LEFT JOIN
DISTINCT filtering
UNION ALL
Subqueries
Common Table Expressions (CTEs)

Window Functions:
ROW_NUMBER()
NTILE()
Running Total using SUM() OVER
Ranking and Top-N Analysis
Percentage-based segmentation

Time-based aggregation (YEAR, MONTH, DATEDIFF)
Core Business KPIs Calculated
Total Revenue
Total Quantity Sold
Average Selling Price
Total Orders (Raw vs Distinct)
Total Customers
Total Products
Customers Who Placed Orders

Analytical Insights Covered

1. Dimension Exploration
Countries represented in the dataset
Product hierarchy (Category → Subcategory → Product)

2. Date Analysis
Sales coverage period
Age distribution of customers

3. Magnitude Analysis
Customers by country and gender
Products by category
Revenue by category
Revenue by customer
Quantity distribution by country

4. Ranking Analysis

Top 5 revenue-generating products
Bottom 5 products
Top 10 customers by revenue
Customers with fewest orders

5. Advanced Analysis
Top 2 products per country
Top 10% revenue-generating customers
Revenue segmentation using NTILE
Running total revenue per country over time

Project Structure
sales_analytics_exploration.sql
README.md

How to Run the Script

Open SQL Server Management Studio (SSMS)
Connect to your SQL Server instance
Create or restore the datawarehouseanalytics database
Ensure tables exist under the gold schema
Run the script file sales_analytics_exploration.sql

Why This Project Matters
This project demonstrates:
Ability to work with dimensional models
Strong understanding of business metrics
Clean SQL coding practices
Advanced window function usage
Analytical thinking beyond basic queries

It reflects practical skills required in Data Analyst and Business Intelligence roles.


Author

Sadique Shoaib
Data Analyst
Skilled in SQL, Power BI, Excel, and Python
