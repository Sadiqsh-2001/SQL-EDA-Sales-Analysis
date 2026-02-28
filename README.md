SQL Sales EDA Project (Microsoft SQL Server)
🔹 Project Overview

This project performs Exploratory Data Analysis (EDA) on a retail sales dataset using Microsoft SQL Server (T-SQL).

The objective of this project is to analyze sales transactions, customer behavior, and product performance using structured SQL queries and business-driven analytical thinking.

The dataset follows a Star Schema model, making it suitable for analytical reporting and business intelligence use cases.

🏗 Data Model

The database consists of:
gold.fact_sales – Transaction-level sales data
gold.dim_customers – Customer dimension
gold.dim_products – Product dimension

This structure allows efficient joins and aggregation for analytical queries.

🎯 Project Objectives

Explore and understand the dataset structure
Identify key business KPIs
Analyze revenue distribution
Compare performance across dimensions
Identify top and bottom performers
Generate business-ready insights using SQL

🔍 Analysis Performed

1️⃣ Dimension Exploration

Identified unique customer countries
Explored product hierarchy (Category → Subcategory → Product)
Analyzed customer demographics

2️⃣ Time-Based Analysis

Identified first and last order dates
Calculated total data coverage period
Assessed customer age distribution

3️⃣ KPI & Business Metrics
Calculated core metrics such as:
Total Sales Revenue
Total Quantity Sold
Average Selling Price
Total Unique Orders
Total Customers
Customers Who Placed Orders

4️⃣ Magnitude Analysis

Compared performance across:
Revenue by Product Category
Customers by Country
Customers by Gender
Revenue by Individual Customer
Sales Distribution Across Countries

5️⃣ Ranking & Performance Analysis

Used SQL window functions to identify:
Top 5 Revenue-Generating Products
Bottom 5 Worst-Performing Products
Top 10 Customers by Revenue
3 Customers with the Fewest Orders

SQL Techniques Used

This project demonstrates practical usage of:

SELECT, DISTINCT
GROUP BY
JOIN (LEFT JOIN)
COUNT(DISTINCT)
SUM(), AVG()
DATEDIFF()
ROW_NUMBER() OVER(),
RANK(),
UNION ALL
SUBQUERIES

Aggregation & Ranking logic

📈 Key Business Insights

The dataset covers multiple years of transactional sales data.
Revenue is concentrated among specific product categories.
A small group of customers generates a significant portion of revenue.
Product performance varies significantly across categories.
Geographic distribution impacts sales volume.
These insights can help businesses improve:
Inventory planning
Marketing strategies
Customer targeting
Revenue optimization

🚀 Future Enhancements

Monthly & Yearly Revenue Trend Analysis
Customer Cohort Analysis
RFM (Recency, Frequency, Monetary) Segmentation
Customer Lifetime Value (CLV) Calculation
Power BI Dashboard Integration

🧠 What I Learned

Writing business-focused analytical queries
Working with star schema data models
Implementing ranking using window functions
Translating raw data into meaningful business insights
Structuring SQL projects professionally for GitHub

📌 Tools Used

Microsoft SQL Server
T-SQL
Git & GitHub

👨‍💻 Author

Sadique Shoaib
Data Analyst | SQL | Power BI | Data Analytics