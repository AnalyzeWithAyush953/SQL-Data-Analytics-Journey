use superstore_sales;
-- Module 3 --
-- Aggregation and grouping-- 
-- Begineer level --
-- Topic 3 - Question 31 (Aggregations & Grouping - Beginner Level)
-- 📝 Scenario:
-- The executive leadership team wants a quick, high-level financial health summary of the entire e-commerce business across all recorded transactions in the sales table. 
-- They need an overall summary report without breaking down by any specific category or region yet.
-- 🎯 Your Task:
-- Write a clean, optimized SQL query to calculate the following 5 overall business summary metrics from the sales table:
-- total_orders: Total number of transaction rows recorded in the table (COUNT(*)).
-- total_revenue: Sum of total sales generated (SUM(sales)), rounded cleanly to 2 decimal places using ROUND().
-- total_profit: Sum of operational profit (SUM(profit)), rounded to 2 decimal places.
-- average_order_value: The average sales value per order (AVG(sales)), rounded to 2 decimal places.
-- max_single_sale: The maximum sales value recorded in a single transaction (MAX(sales)).
-- ⚠️ Edge Case Instructions:
-- Wrap aggregate functions (SUM, AVG) inside ROUND(expression, 2) to ensure clean presentation for business executives.
-- Note that when applying aggregate functions without a GROUP BY clause, SQL treats the entire dataset as one single group and returns exactly 1 summary row.
-- Alias the calculated fields strictly as named above.

SELECT 
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(sales), 2) AS average_order_value,
    MAX(sales) AS max_single_sale
FROM sales;

-- Question 32 (Aggregations & Grouping - Beginner Level)
-- 📝 Scenario:
-- The product management team wants to analyze the sales and profitability performance across different product categories in the sales table. 
-- Instead of looking at individual order rows, they need a aggregated summary grouped by each distinct product category.

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query to aggregate data from the sales table by category and 
-- calculate the following 4 category-level summary metrics:
-- category: The product category name.
-- total_category_orders: Total number of orders placed in each category (COUNT(*)).
-- total_category_revenue: Sum of sales generated per category (SUM(sales)), rounded cleanly to 2 decimal places using ROUND().
-- total_category_profit: Sum of profit generated per category (SUM(profit)), rounded to 2 decimal places using ROUND().
-- avg_order_value: The average sales amount per order within that category (AVG(sales)), rounded to 2 decimal places.
-- 📋 Execution Flow & Instructions:
-- Group the records by category using the GROUP BY category clause.
-- Sort the final output so that the category generating the highest total revenue appears first (ORDER BY total_category_revenue DESC).
-- Alias all aggregate fields strictly as named above.

SELECT 
    category,
    COUNT(*) AS total_category_orders,
    ROUND(SUM(sales), 2) AS total_category_revenue,
    ROUND(SUM(profit), 2) AS total_category_profit,
    ROUND(AVG(sales), 2) AS avg_order_value
FROM sales
GROUP BY category
ORDER BY total_category_revenue DESC;

-- Topic 3 - Question 33 (Aggregations & Grouping - Beginner Level)
-- 📝 Scenario:
-- The fulfillment operations team wants to analyze order processing efficiency across different customer segments in the sales table.
--  They specifically want to compare total order volume against actual shipped volume per segment:
-- Total Orders: Count of all transaction records placed in that segment.
-- Shipped Orders: Count of orders that have actually been shipped (where ship_date is not NULL).
-- Pending Fulfillment Volume: The exact difference between total orders and shipped orders.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query to group records by segment and compute the following 4 fields:
-- segment: The customer segment name (e.g., 'Consumer', 'Corporate', 'Home Office').
-- total_orders_count: Total row count per segment using COUNT(*).
-- shipped_orders_count: Total shipped orders count per segment using COUNT(ship_date).
-- unshipped_orders_count: The calculated mathematical difference: COUNT(*) - COUNT(ship_date).
-- 📋 Execution Instructions:
-- Group records by segment using GROUP BY segment.
-- Sort results in descending order of total_orders_count (ORDER BY total_orders_count DESC).

SELECT 
    segment,
    COUNT(*) AS total_orders_count,
    COUNT(ship_date) AS shipped_orders_count,
    (COUNT(*) - COUNT(ship_date)) AS unshipped_orders_count
FROM sales
GROUP BY segment
ORDER BY total_orders_count DESC;

-- COMPLETED BEGINEER LEVEL --

-- INTERMEDIATE LEVEL QUESTIONS -- 
--  Topic 3 - Question 34 (Aggregations & Grouping - Intermediate Level)
-- 📝 Scenario:
-- The regional sales strategy team needs a granular breakdown of sales performance across different geographic markets. Instead of grouping by just a single dimension, they want a hierarchical analysis that breaks down performance first by region and then by category inside each region.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query to group records by both region and category, and compute the following 5 summary metrics for each region-category combination:
-- region: The sales region (e.g., 'East', 'West', 'Central', 'South').
-- category: The product category (e.g., 'Technology', 'Furniture', 'Office Supplies').
-- total_orders: Total number of transaction rows recorded (COUNT(*)).
-- total_revenue: Sum of total sales generated (SUM(sales)), rounded cleanly to 2 decimal places using ROUND().
-- total_profit: Sum of operational profit (SUM(profit)), rounded to 2 decimal places using ROUND().
-- 📋 Execution & Ordering Instructions:
-- Group records across two dimensions using: GROUP BY region, category.
-- Sort the final output hierarchically:
-- First alphabetically by region ASC
-- Second by highest total revenue first: total_revenue DESC.
-- Alias all calculated fields strictly as specified above.

SELECT 
    region,
    category,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY region, category
ORDER BY region ASC, total_revenue DESC;

-- Topic 3 - Question 35 (Aggregations & Grouping - Intermediate Level)
-- 📝 Scenario:
-- The regional executive committee wants to identify high-performing regional product categories. However, they want to filter out low-value individual transactions first to avoid skewing metrics, and then only evaluate product categories that generated significant total sales volume.
-- Specifically, the logic requires:
-- Pre-Aggregation Filter: Evaluate individual transaction records where sales > 50 (ignoring small micro-transactions).
-- Post-Aggregation Filter: Group remaining data by category and filter the aggregated groups to return only categories where total_category_revenue > 100,000.
-- 🎯 Your Task:
-- Write a clean, production-grade, optimized SQL query to pull category summary metrics from the sales table satisfying both conditions:
-- category: The product category name.
-- total_orders: Count of qualifying orders (COUNT(*)).
-- total_category_revenue: Sum of sales (SUM(sales)), rounded cleanly to 2 decimal places using ROUND().
-- total_category_profit: Sum of profit (SUM(profit)), rounded to 2 decimal places using ROUND().
-- 📋 Execution & Performance Rules:
-- Filter row-level records where sales > 50 using the WHERE clause before grouping.
-- Group records using GROUP BY category.
-- Filter aggregated group results where SUM(sales) > 100000 using the HAVING clause.
-- Sort output in descending order of total_category_revenue (ORDER BY total_category_revenue DESC).

SELECT 
    category,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_category_revenue,
    ROUND(SUM(profit), 2) AS total_category_profit
FROM sales
WHERE sales > 50
GROUP BY category
HAVING SUM(sales) > 100000
ORDER BY total_category_revenue DESC;

-- Topic 3 - Question 36 (Aggregations & Grouping - Intermediate Level)
-- 📝 Scenario:
-- The financial reporting team is auditing product returns and discounts across customer segments. In the raw dataset, some orders have a NULL discount value (indicating no discount was applied).
-- When executive reports are generated, returning NULL for average discount percentages or total discount dollar amounts creates confusion. Management wants a clean report
-- where missing discount entries are safely treated as 0.00 before aggregation, and any potential NULL aggregate outputs default cleanly to 0.🎯 Your Task:Write a clean, production-grade SQL query to group the sales table by segment and compute the following 4 summary metrics:
-- segment: The customer segment name.
-- total_orders: Total count of transaction rows per segment (COUNT(*)).
-- total_revenue: Sum of sales (SUM(sales)), rounded cleanly to 2 decimal places using ROUND().
-- safe_avg_discount_pct: The average discount percentage, calculated safely by converting NULL values in the discount column to 0 using COALESCE(discount, 0), multiplied by 100, and rounded to 2 decimal places.
-- safe_total_discount_given: The total dollar discount amount calculated as SUM(sales * COALESCE(discount, 0)), wrapped inside COALESCE(..., 0) and rounded to 2 decimal places.
-- 📋 Execution Instructions:
-- Group records by segment using GROUP BY segment.
-- Handle potential NULLs in the column prior to and after aggregation using COALESCE().
-- Sort results in descending order of total_revenue (ORDER BY total_revenue DESC).

SELECT 
    segment,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(AVG(COALESCE(discount, 0)) * 100, 2) AS safe_avg_discount_pct,
    COALESCE(ROUND(SUM(sales * COALESCE(discount, 0)), 2), 0.00) AS safe_total_discount_given
FROM sales
GROUP BY segment
ORDER BY total_revenue DESC;


-- ADVANCED LEVEL QUESTION --
-- Topic 3 - Question 37 (Aggregations & Grouping - Advanced Level)
-- 📝 Scenario:
-- The executive finance team wants a single consolidated summary report that evaluates profitability across different sales regions in the sales table. Instead of returning profitable orders and loss-making orders on separate rows, they want a pivot-style summary on a single row per region.
-- Specifically, for each region, they need:
-- Total Orders: Count of all orders in that region.
-- Profitable Orders Count: Count of orders where profit > 0.
-- Loss Orders Count: Count of orders where profit < 0.
-- Total Profitable Revenue: Sum of sales for orders where profit > 0.
-- Total Loss Amount: Sum of profit for orders where profit < 0 (converted to a positive figure using ABS()).

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using Conditional Aggregation (SUM/COUNT + CASE WHEN) to group the sales table by region and compute these 6 fields:
-- region: The sales region.
-- total_orders: Total orders (COUNT(*)).
-- profitable_orders: Count of profitable orders using COUNT(CASE WHEN profit > 0 THEN 1 END).
-- loss_orders: Count of loss-making orders using COUNT(CASE WHEN profit < 0 THEN 1 END).
-- profitable_revenue: Sum of sales for profitable orders using ROUND(SUM(CASE WHEN profit > 0 THEN sales ELSE 0 END), 2).
-- total_loss_amount: Total loss amount as a positive figure using ROUND(ABS(SUM(CASE WHEN profit < 0 THEN profit ELSE 0 END)), 2).
-- 📋 Execution Instructions:
-- Group records by region using GROUP BY region.
-- Sort results in descending order of profitable_revenue (ORDER BY profitable_revenue DESC).

SELECT 
    region,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN profit > 0 THEN 1 END) AS profitable_orders,
    COUNT(CASE WHEN profit < 0 THEN 1 END) AS loss_orders,
    ROUND(SUM(CASE WHEN profit > 0 THEN sales ELSE 0 END), 2) AS profitable_revenue,
    ROUND(ABS(SUM(CASE WHEN profit < 0 THEN profit ELSE 0 END)), 2) AS total_loss_amount
FROM sales
GROUP BY region
ORDER BY profitable_revenue DESC;

-- Topic 3 - Question 38 (Aggregations & Grouping - Advanced Level)
-- 📝 Scenario:
-- The customer tier and pricing strategy team wants to segment transactions into distinct
-- Deal Size Tiers based on total dollar value per order in the sales table:

-- High-Value Deal: Orders where sales >= 1000.
-- Mid-Value Deal: Orders where sales >= 250 and sales < 1000.
-- Low-Value Deal: Orders where sales < 250.
-- Management needs an aggregated summary comparing total order counts, combined sales, and total profit across these 3 custom sales tiers.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query to group data dynamically by the CASE WHEN expression and compute the following metrics:

-- deal_tier: The evaluated deal size label ('High-Value Deal', 'Mid-Value Deal', 'Low-Value Deal').
-- total_orders: Total count of orders falling into each tier (COUNT(*)).
-- total_tier_revenue: Total revenue generated by each tier (SUM(sales)), rounded cleanly to 2 decimal places using ROUND().
-- total_tier_profit: Total profit generated by each tier (SUM(profit)), rounded to 2 decimal places using ROUND().
-- avg_deal_size: The average sales amount per order within that tier (AVG(sales)), rounded to 2 decimal places.
-- 📋 Execution Instructions:
-- Construct the CASE WHEN statement in the SELECT list and repeat the expression in the GROUP BY clause.
-- Sort results in descending order of total_tier_revenue (ORDER BY total_tier_revenue DESC).

SELECT 
    CASE 
        WHEN sales >= 1000 THEN 'High-Value Deal'
        WHEN sales >= 250 THEN 'Mid-Value Deal'
        ELSE 'Low-Value Deal'
    END AS deal_tier,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_tier_revenue,
    ROUND(SUM(profit), 2) AS total_tier_profit,
    ROUND(AVG(sales), 2) AS avg_deal_size
FROM sales
GROUP BY 
CASE 
        WHEN sales >= 1000 THEN 'High-Value Deal'
        WHEN sales >= 250 THEN 'Mid-Value Deal'
        ELSE 'Low-Value Deal'
    END
ORDER BY total_tier_revenue DESC;

-- Topic 3 - Question 39 (Aggregations & Grouping - Advanced Level)
-- 📝 Scenario:
-- The executive planning and finance team wants a monthly time-series breakdown of overall company performance for the year 2023 from the sales table:
-- Monthly Granularity: The data must be grouped chronologically by Year and Month (e.g., '2023-01', '2023-02', etc.).
-- Key Financial Metrics: Calculate total order volume, total monthly sales, total monthly profit, and average order value per month.
-- Filtering Scope: Include only transactions placed within the year 2023 (YEAR(order_date) = 2023).

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query to extract 2023 order records, group them by month, and compute the following 5 fields:
-- year_month: The formatted string showing Year and Month (DATE_FORMAT(order_date, '%Y-%m')).
-- total_monthly_orders: Total transaction rows recorded for that month (COUNT(*)).
-- total_monthly_revenue: Sum of monthly sales (SUM(sales)), rounded cleanly to 2 decimal places using ROUND().
-- total_monthly_profit: Sum of monthly profit (SUM(profit)), rounded to 2 decimal places using ROUND().
-- avg_monthly_order_value: The average sales per order in that month (AVG(sales)), rounded to 2 decimal places.
-- 📋 Execution & Ordering Instructions:
-- Filter 2023 orders in the WHERE clause: WHERE YEAR(order_date) = 2023.
-- Group records chronologically: GROUP BY DATE_FORMAT(order_date, '%Y-%m') or GROUP BY YEAR(order_date), MONTH(order_date).
-- Sort results chronologically starting from January 2023: ORDER BY year_month ASC

SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_monthly_orders,
    ROUND(SUM(sales), 2) AS total_monthly_revenue,
    ROUND(SUM(profit), 2) AS total_monthly_profit,
    ROUND(AVG(sales), 2) AS avg_monthly_order_value
FROM sales
WHERE YEAR(order_date) = 2023
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_month ASC;
