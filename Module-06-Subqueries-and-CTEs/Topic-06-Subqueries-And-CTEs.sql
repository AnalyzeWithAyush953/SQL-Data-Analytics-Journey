use superstore_sales;
-- SUBQUERIES & CTE(Common Table Expression) --  

-- Topic 6 - Question 60 (Single-Row / Scalar Subquery - Beginner Level)
-- 📝 Scenario:
-- The sales performance manager wants to identify high-value sales orders. They need a list of all orders from the sales table whose sales amount is strictly greater than the overall average sales amount across all transactions in the entire database.
-- Since the benchmark value (overall average sales) is dynamic and changes as new data enters the system, hardcoding a number is not allowed. You must calculate the benchmark dynamically using an inner Scalar Subquery.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a Scalar Subquery in the WHERE clause:
-- Select order_id, order_date, customer_name, category, and sales.
-- Filter rows using WHERE sales > (SELECT AVG(sales) FROM sales).
-- Sort results in descending order of sales (ORDER BY sales DESC).
-- Limit the final output to 10 rows (LIMIT 10).
SELECT 
    order_id,
    order_date,
    customer_name,
    category,
    sales
FROM sales
WHERE sales > (SELECT AVG(sales) FROM sales)
ORDER BY sales DESC
LIMIT 10;

-- Question 61 (Multi-Row Subquery with IN - Beginner Level)
-- 📝 Scenario:
-- The product strategy team wants to pull order details from the sales table, but ONLY for product categories that are highly profitable (where the cumulative category profit across all transactions exceeds $30,000).
-- Because high-performing categories change as new sales data is logged, hardcoding category names (like 'Technology' or 'Office Supplies') is strictly forbidden. You must write an inner Multi-Row Subquery using GROUP BY and HAVING to dynamically pass the list of qualifying categories to the outer query using the IN operator.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a Multi-Row Subquery with IN:
-- Select order_id, order_date, customer_name, category, sales, and profit.
-- Filter using WHERE category IN (...).
-- Inside the subquery, select category from sales, grouped by category, having SUM(profit) > 30000.
-- Sort results in descending order of sales (ORDER BY sales DESC).
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    order_id,
    order_date,
    customer_name,
    category,
    sales,
    profit
FROM sales
WHERE category IN (SELECT category FROM sales
    GROUP BY category
    HAVING SUM(profit) > 30000)
ORDER BY sales DESC
LIMIT 10;

-- Question 62 (Q62)
-- 🇬🇧 English: Topic 6 - Question 62 (Subquery in the SELECT Clause - Beginner Level)
-- 📝 Scenario:
-- The pricing strategy team wants to compare individual transaction amounts against overall platform benchmarks. They need a report listing order transactions alongside the overall average sales amount across the entire database, plus the absolute difference between the order's sales amount and that global average.
-- Because the global average needs to appear on every single row without collapsing the individual transaction rows (which a GROUP BY would do), 
-- you must place a Scalar Subquery directly inside the SELECT list.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a Scalar Subquery in the SELECT clause:
-- Select order_id, customer_name, category, and sales.
-- Add a subquery column overall_avg_sales: (SELECT ROUND(AVG(sales), 2) FROM sales).
-- Add a computed column variance_from_avg: ROUND(sales - (SELECT AVG(sales) FROM sales), 2).
-- Sort results in descending order of sales (ORDER BY sales DESC).
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    order_id,
    customer_name,
    category,
    sales,
    (SELECT ROUND(AVG(sales), 2) FROM sales) AS overall_avg_sales,
    ROUND(sales - (SELECT AVG(sales) FROM sales), 2) AS variance_from_avg
FROM sales
ORDER BY sales DESC
LIMIT 10;

-- INTERMEDIATE LEVEL --
-- Question 63 (Correlated Subquery with EXISTS / NOT EXISTS - Intermediate Level)
-- 📝 Scenario:
-- The customer relationship management (CRM) team is auditing customer purchasing patterns. They want to identify registered customer profiles in the customers table who have placed at least one order with a discount greater than 10% (0.10) in the sales table.
-- Rather than joining the tables and performing DISTINCT aggregations, management wants you to write a high-performance Correlated Subquery using EXISTS.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a Correlated Subquery with EXISTS:
-- Select c.customer_id, c.customer_name, c.segment, and c.state from customers c.
-- Filter rows using WHERE EXISTS (...).
-- Inside the inner subquery, reference sales s and correlate it to the outer query row on s.customer_id = c.customer_id.
-- Add the discount threshold condition inside the inner subquery: AND s.discount > 0.10.
-- Sort results by c.customer_name ASC and limit output to 10 rows (LIMIT 10).

SELECT 
    c.customer_id,
    c.customer_name,
    c.segment,
    c.state
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM sales s
    WHERE s.customer_id = c.customer_id
      AND s.discount > 0.10
)
ORDER BY c.customer_name ASC
LIMIT 10;


-- Question 64 (Subquery in the FROM Clause / Derived Table - Intermediate Level)
-- 📝 Scenario:
-- The regional operations manager wants to identify customer accounts that generate a high volume of orders. Specifically, they want a list of customer names, their state, and their total order count, but ONLY for customers who have placed strictly more than 5 orders in total.
-- While this can be done using a standard HAVING clause, management specifically wants you to use a Derived Table (Subquery in the FROM clause) to pre-aggregate order counts per customer first, and then apply a clean WHERE filter on the outer query.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a Derived Table in the FROM clause:
-- In the inner subquery (aliased as cust_summary), aggregate the sales table grouped by customer_id and customer_name to calculate total_orders (COUNT(order_id)).
-- In the outer query, select cust_summary.customer_id, cust_summary.customer_name, and cust_summary.total_orders.
-- Filter the outer query using WHERE cust_summary.total_orders > 5.
-- Sort results in descending order of total_orders (ORDER BY cust_summary.total_orders DESC).
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    cust_summary.customer_id,
    cust_summary.customer_name,
    cust_summary.total_orders
FROM (
    SELECT 
        customer_id,
        customer_name,
        COUNT(order_id) AS total_orders
    FROM sales
    GROUP BY 
        customer_id,
        customer_name
) cust_summary
WHERE cust_summary.total_orders > 5
ORDER BY cust_summary.total_orders DESC
LIMIT 10;

-- uestion 65 (Basic CTE with WITH Clause - Intermediate Level)
-- 📝 Scenario:
-- The marketing team is designing a loyalty rewards campaign. They want to identify top-tier corporate customers from the sales table.
-- Specifically, they need a report listing customers in the 'Corporate' segment whose total overall spending exceeds $10,000.
-- Instead of writing a complex nested subquery in the FROM or WHERE clause, management wants you to structure the solution using a clean, readable Common Table Expression (CTE) with the WITH clause.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE (WITH clause):
-- Define a CTE named corporate_customer_summary:
-- Aggregate the sales table grouped by customer_id, customer_name, and segment.
-- Filter for segment = 'Corporate'.
-- Calculate total_spend (ROUND(SUM(sales), 2)) and total_orders (COUNT(order_id)).
-- In the main query following the CTE:
-- Select customer_id, customer_name, total_spend, and total_orders from corporate_customer_summary.
-- Filter using WHERE total_spend > 10000.
-- Sort by total_spend DESC.
-- Limit the output to 10 rows (LIMIT 10).

WITH corporate_customer_summary AS (
    SELECT 
        customer_id,
        customer_name,
        segment,
        COUNT(order_id) AS total_orders,
        ROUND(SUM(sales), 2) AS total_spend
    FROM sales
    WHERE segment = 'Corporate'
    GROUP BY 
        customer_id,
        customer_name,
        segment
)
SELECT 
    customer_id,
    customer_name,
    total_spend,
    total_orders
FROM corporate_customer_summary
WHERE total_spend > 10000
ORDER BY total_spend DESC
LIMIT 10;

-- topic 6 - Question 66 (Chained Multiple CTEs - Advanced Level)
-- 📝 Scenario:
-- The executive leadership team wants to benchmark regional category performance. They want to identify top-performing regional product categories that generate both high sales volume and above-average profitability.
-- To solve this step-by-step without writing cluttered nested queries, management wants you to chain two CTEs together:
-- CTE 1 (regional_category_metrics): Aggregate total sales and total profit per region and category.
-- CTE 2 (overall_category_benchmarks): Calculate the overall average profit across all regional category combinations.
-- Main Query: Join or filter using both CTEs to return regional categories whose total profit is strictly greater than the overall benchmark average.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using Chained CTEs:
-- Define the first CTE regional_category_metrics:
-- Aggregate sales grouped by region and category.
-- Calculate total_sales (ROUND(SUM(sales), 2)) and total_profit (ROUND(SUM(profit), 2)).
-- Define the second CTE overall_category_benchmarks:
-- Query directly from regional_category_metrics to compute avg_regional_profit (ROUND(AVG(total_profit), 2)).
-- In the main query:
-- Select rcm.region, rcm.category, rcm.total_sales, rcm.total_profit, and ocb.avg_regional_profit.
-- Join regional_category_metrics rcm with overall_category_benchmarks ocb on a 1=1 cross join condition.
-- Filter using WHERE rcm.total_profit > ocb.avg_regional_profit.
-- Sort by rcm.total_profit DESC and limit output to 10 rows (LIMIT 10).

WITH regional_category_metrics AS (
    SELECT 
        region,
        category,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
    FROM sales
    GROUP BY 
        region,
        category
),
overall_category_benchmarks AS (
    SELECT 
        ROUND(AVG(total_profit), 2) AS avg_regional_profit
    FROM regional_category_metrics
)
SELECT 
    rcm.region,
    rcm.category,
    rcm.total_sales,
    rcm.total_profit,
    ocb.avg_regional_profit
FROM regional_category_metrics rcm
CROSS JOIN overall_category_benchmarks ocb
WHERE rcm.total_profit > ocb.avg_regional_profit
ORDER BY rcm.total_profit DESC
LIMIT 10;

-- Question 67 (Subquery Refactoring to CTEs - Advanced Level)
-- 📝 Scenario:
-- A legacy reporting pipeline contains a messy, deeply nested subquery that calculates customer order metrics. The query finds customers whose total revenue is higher than the overall average revenue per customer, and whose total order count is also higher than the average order count per customer.
-- Because the legacy query uses multiple nested subqueries in both the FROM and WHERE clauses, it is difficult to read and maintain. Management wants you to refactor this query into clean, modular CTEs.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query that refactors nested subqueries into CTEs:
-- CTE 1 (customer_totals): Group sales by customer_id and customer_name to calculate total_revenue (ROUND(SUM(sales), 2)) and total_orders (COUNT(order_id)).CTE 2 (overall_averages): Query from customer_totals to compute avg_customer_revenue (ROUND(AVG(total_revenue), 2)) and avg_customer_orders (ROUND(AVG(total_orders), 2)).
-- Main Query: Select ct.customer_id, ct.customer_name, ct.total_revenue, ct.total_orders, oa.avg_customer_revenue, and oa.avg_customer_orders.
-- Join customer_totals ct with overall_averages oa on a 1=1 cross join condition.
-- Filter rows using: WHERE ct.total_revenue > oa.avg_customer_revenue AND ct.total_orders > oa.avg_customer_orders.
-- Sort by ct.total_revenue DESC and limit output to 10 rows (LIMIT 10).

WITH customer_totals AS (
    SELECT 
        customer_id,
        customer_name,
        ROUND(SUM(sales), 2) AS total_revenue,
        COUNT(order_id) AS total_orders
    FROM sales
    GROUP BY 
        customer_id,
        customer_name
),
overall_averages AS (
    SELECT 
        ROUND(AVG(total_revenue), 2) AS avg_customer_revenue,
        ROUND(AVG(total_orders), 2) AS avg_customer_orders
    FROM customer_totals
)
SELECT 
    ct.customer_id,
    ct.customer_name,
    ct.total_revenue,
    ct.total_orders,
    oa.avg_customer_revenue,
    oa.avg_customer_orders
FROM customer_totals ct
CROSS JOIN overall_averages oa
WHERE ct.total_revenue > oa.avg_customer_revenue
  AND ct.total_orders > oa.avg_customer_orders
ORDER BY ct.total_revenue DESC
LIMIT 10;

-- Question 68 (Recursive CTE Series & Sequence Generation - Advanced Level)
-- 📝 Scenario:
-- The business analytics team is building a daily revenue trend report for the first week of December 2023 (2023-12-01 to 2023-12-07).
-- When querying transactional tables like sales, if no orders occurred on a specific date (e.g., December 3rd), standard SQL queries completely drop that date from the output. To ensure zero-sales gap days are displayed with $0.00 revenue, you must first generate a continuous date sequence using a Recursive CTE (WITH RECURSIVE), and then LEFT JOIN the daily sales aggregates to this generated sequence.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a Recursive CTE:
-- Define a recursive CTE named date_generator:
-- Anchor Member: Select '2023-12-01' as calendar_date.
-- Recursive Member: Add 1 day (DATE_ADD(calendar_date, INTERVAL 1 DAY)).
-- Termination Condition: Stop recursion when calendar_date < '2023-12-07'.
-- Define a second CTE named daily_sales_summary:
-- Aggregate sales grouped by DATE(order_date).
-- Compute daily_revenue (ROUND(SUM(sales), 2)) and daily_orders (COUNT(order_id)).
-- In the main query:
-- Select dg.calendar_date, COALESCE(dss.daily_revenue, 0) AS total_sales, and COALESCE(dss.daily_orders, 0) AS total_orders.
-- LEFT JOIN daily_sales_summary dss ON dg.calendar_date = dss.order_day.
-- Sort by dg.calendar_date ASC.

WITH RECURSIVE date_generator AS (
    -- Anchor Member: Starting date
    SELECT CAST('2023-12-01' AS DATE) AS calendar_date
    
    UNION ALL
    
    -- Recursive Member: Increment by 1 day
    SELECT DATE_ADD(calendar_date, INTERVAL 1 DAY)
    FROM date_generator
    WHERE calendar_date < '2023-12-07' -- Termination Condition
),
daily_sales_summary AS (
    SELECT 
        DATE(order_date) AS order_day,
        ROUND(SUM(sales), 2) AS daily_revenue,
        COUNT(order_id) AS daily_orders
    FROM sales
    WHERE order_date >= '2023-12-01' 
      AND order_date <= '2023-12-07'
    GROUP BY DATE(order_date)
)
SELECT 
    dg.calendar_date,
    COALESCE(dss.daily_revenue, 0.00) AS total_sales,
    COALESCE(dss.daily_orders, 0) AS total_orders
FROM date_generator dg
LEFT JOIN daily_sales_summary dss 
    ON dg.calendar_date = dss.order_day
ORDER BY dg.calendar_date ASC;

