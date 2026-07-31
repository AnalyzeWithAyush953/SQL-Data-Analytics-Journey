use superstore_sales;
-- =============================================================================
-- Database Setup for Module 05 (Joins & Set Operations):
-- Created a separate `customers` table alongside the main `sales` table.
-- Added guest orders in `sales` that do not exist in `customers`.
-- Added new customer profiles in `customers` who have not placed any orders yet.

-- Why this setup?
-- This multi-table setup simulates real-world database issues (missing records, guest users, and non-buying customers) 
-- to test INNER JOIN, LEFT JOIN, RIGHT JOIN, and Anti-Joins effectively.
--  Purpose: To evaluate INNER, LEFT, RIGHT, and Anti-Joins against realistic unmapped data.
-- =============================================================================

-- Create a helper customers table for practicing JOINs
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    state VARCHAR(50),
    region VARCHAR(50)
);

show tables;

-- Insert sample customer demographic records
INSERT IGNORE INTO customers (customer_id, customer_name, segment, state, region)
SELECT DISTINCT 
    customer_id, 
    customer_name, 
    segment, 
    state, 
    region 
FROM sales;

select count(*) from customers;

-- 1. Insert 8 new customers who have NEVER bought anything --
INSERT INTO customers (customer_id, customer_name, segment, state, region)
VALUES 
    ('CUST-NEW-003', 'Rahul Verma', 'Corporate', 'Karnataka', 'South'),
    ('CUST-NEW-004', 'Ananya Roy', 'Home Office', 'West Bengal', 'East'),
    ('CUST-NEW-005', 'Vikram Singh', 'Consumer', 'Punjab', 'North'),
    ('CUST-NEW-006', 'Sneha Reddy', 'Consumer', 'Telangana', 'South'),
    ('CUST-NEW-007', 'Rohan Mehta', 'Corporate', 'Maharashtra', 'West'),
    ('CUST-NEW-008', 'Kavita Iyer', 'Home Office', 'Tamil Nadu', 'South');

INSERT INTO customers (customer_id, customer_name, segment, state, region)
VALUES 
    ('CUST-NEW-001', 'Aarav Sharma', 'Consumer', 'Delhi', 'North'),
    ('CUST-NEW-002', 'Priya Patel', 'Corporate', 'Gujarat', 'West');
    
-- Inserting 5 "Guest" sales orders with customer IDs that DO NOT exist in the customers table
INSERT INTO sales (order_id, order_date, ship_mode, customer_id, customer_name, segment, country, city, state, postal_code, region, product_id, category, sub_category, product_name, sales, quantity, discount, profit)
VALUES 
    ('IN-2023-99901', '2023-11-15', 'Standard Class', 'GUEST-999', 'Guest User 1', 'Consumer', 'India', 'Mumbai', 'Maharashtra', '400001', 'West', 'OFF-PA-1000', 'Office Supplies', 'Paper', 'Xerox Paper', 150.00, 2, 0.00, 45.00),
    ('IN-2023-99902', '2023-12-01', 'First Class', 'GUEST-888', 'Guest User 2', 'Corporate', 'India', 'Delhi', 'Delhi', '110001', 'North', 'TEC-AC-2000', 'Technology', 'Accessories', 'USB Cable', 300.00, 1, 0.00, 90.00),
    ('IN-2023-99903', '2023-12-10', 'Same Day', 'GUEST-777', 'Guest User 3', 'Home Office', 'India', 'Bengaluru', 'Karnataka', '560001', 'South', 'FUR-CH-3000', 'Furniture', 'Chairs', 'Office Chair', 450.00, 1, 0.10, 85.00),
    ('IN-2023-99904', '2023-12-18', 'Second Class', 'GUEST-666', 'Guest User 4', 'Consumer', 'India', 'Kolkata', 'West Bengal', '700001', 'East', 'OFF-BI-4000', 'Office Supplies', 'Binders', 'Ring Binder', 80.00, 4, 0.00, 20.00),
    ('IN-2023-99905', '2023-12-25', 'Standard Class', 'GUEST-555', 'Guest User 5', 'Corporate', 'India', 'Ahmedabad', 'Gujarat', '380001', 'West', 'TEC-PH-5000', 'Technology', 'Phones', 'Wireless Earbuds', 220.00, 1, 0.05, 50.00);
    
select * from customers;
select * from sales; 

-- DATABASE SETUP COMPLETION DONE -- 
-- JOINS & SETS OPERATIONS BEGINEER LEVEL --
-- 🟢 Question 51 (Q51): INNER JOIN Basics
-- 🇬🇧 English: Scenario & Task
-- 📝 Scenario:
-- The customer analytics team wants to analyze customer purchasing behavior 
-- by enriching order data from the sales table with detailed customer demographics stored in the customers table.
-- Management only wants to see orders that successfully match a registered customer in the customers table. 
-- Therefore, an INNER JOIN must be used.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using an INNER JOIN to combine the sales table and customers table:
-- Select s.order_id, s.order_date, c.customer_name, c.state, and s.sales.
-- Join sales (alias s) with customers (alias c) on s.customer_id = c.customer_id.
-- Sort results by order_date descending (ORDER BY s.order_date DESC).
-- Limit the final output to 10 rows (LIMIT 10).  
SELECT 
    s.order_id,
    s.order_date,
    c.customer_name,
    c.state,
    s.sales
FROM sales s
INNER JOIN customers c 
    ON s.customer_id = c.customer_id
ORDER BY s.order_date DESC
LIMIT 10;

-- 🟢 Question 52 (Q52): LEFT JOIN & Finding Unmapped Data
-- 🇬🇧 English: Scenario & Task
-- 📝 Scenario:
-- The database audit team wants a complete list of all transactional orders placed in the sales 
-- table along with customer demographic details from the customers table.
-- Unlike INNER JOIN (which hides orders if customer profile data is missing), 
-- management wants to ensure ALL orders from the sales table are displayed, 
-- even if the customer is an unregistered guest (customer_id not found in customers).
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a LEFT JOIN to combine sales and customers:
-- Select s.order_id, s.order_date, s.customer_id, s.sales, and c.customer_name (from customers).
-- Join sales (alias s) with customers (alias c) on s.customer_id = c.customer_id.
-- Sort results so that unmapped guest orders (where c.customer_name IS NULL) appear at the very top!
-- Limit the output to 10 rows (LIMIT 10).
SELECT 
    s.order_id,
    s.order_date,
    s.customer_id,
    s.sales,
    c.customer_name AS customers_present_in_customer_table
FROM sales s
LEFT JOIN customers c 
    ON s.customer_id = c.customer_id
ORDER BY c.customer_name ASC
LIMIT 10;

-- Question 53 (RIGHT JOIN - Beginner Level)
-- 📝 Scenario:
-- The marketing team is preparing a re-engagement campaign for customer accounts. 
-- They need a list of all registered customer profiles from the customers table along with any associated orders from the sales table.
-- Management wants to ensure ALL customer profiles from the customers table are included, even if a customer has NEVER placed an order. 
-- To keep sales as the left table and customers as the right table in our query structure, a RIGHT JOIN must be used.

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a RIGHT JOIN to combine sales and customers:
-- Select c.customer_id, c.customer_name, c.state, s.order_id, and s.sales.
-- Join sales (alias s) with customers (alias c) on s.customer_id = c.customer_id using RIGHT JOIN.
-- Sort the output so that inactive customers (where s.order_id IS NULL) appear at the very top!
-- 📋 Execution Instructions:
-- Alias sales as s and customers as c (sales s RIGHT JOIN customers c).
-- Prefix all column names with table aliases.
-- Order by s.order_id ASC (so NULL order IDs appear first) and limit the output to 10 rows (LIMIT 10)

SELECT 
    c.customer_id,
    c.customer_name,
    c.state,
    s.order_id,
    s.sales
FROM sales s
RIGHT JOIN customers c 
    ON s.customer_id = c.customer_id
ORDER BY s.order_id ASC
limit 10;

-- INTERMEDIATE LEVEL --
-- Question 54 (FULL OUTER JOIN Emulation - Intermediate Level)
-- 📝 Scenario:
-- The data reconciliation and auditing team needs a complete 360-degree audit report of all transaction records and customer accounts.
-- They want a single unified output containing:
-- All orders that successfully match a registered customer in customers.
-- All orphan/guest orders in sales that have no matching record in customers (guest orders like GUEST-999).
-- All registered customer accounts in customers that have placed 0 orders in sales (inactive accounts like CUST-NEW-001).
-- Since MySQL does not support FULL OUTER JOIN directly, 
-- management wants you to write a dialect-compatible query using LEFT JOIN, RIGHT JOIN, and UNION.

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query to emulate a FULL OUTER JOIN between sales and customers:
-- First Query (LEFT JOIN): Select s.order_id, s.customer_id AS sales_cust_id, c.customer_id AS cust_table_id, c.customer_name, and s.sales from sales s LEFT JOIN customers c ON s.customer_id = c.customer_id.
-- Set Operator (UNION): Combine the first query with the second query using UNION (not UNION ALL).
-- Second Query (RIGHT JOIN): Select the exact same columns in the exact same order using sales s RIGHT JOIN customers c ON s.customer_id = c.customer_id.
-- 📋 Execution Instructions:
-- Use UNION to ensure duplicate matched rows appearing in both LEFT JOIN and RIGHT JOIN are automatically deduplicated.
-- Ensure column selection order and data types match perfectly in both SELECT statements.
-- Sort results so that unmapped/inactive records (where either s.order_id IS NULL or c.customer_name IS NULL) appear at the top.
-- Limit the final output to 10 rows (LIMIT 10)

SELECT 
    s.order_id,
    s.customer_id AS sales_cust_id,
    c.customer_id AS cust_table_id,
    c.customer_name,
    s.sales
FROM sales s
LEFT JOIN customers c 
    ON s.customer_id = c.customer_id

UNION

SELECT 
    s.order_id,
    s.customer_id AS sales_cust_id,
    c.customer_id AS cust_table_id,
    c.customer_name,
    s.sales
FROM sales s
RIGHT JOIN customers c 
    ON s.customer_id = c.customer_id
ORDER BY 
    CASE WHEN order_id IS NULL OR customer_name IS NULL THEN 0 ELSE 1 END ASC
LIMIT 10;

-- Question 55 (Multi-Table Aggregation - Intermediate Level)
-- 📝 Scenario:
-- The executive leadership team wants a customer segmentation summary report. 
-- They want to calculate aggregate metrics per customer from the customers table combined with transaction details from the sales table.
-- Specifically, for every registered customer in the customers table, management wants to know:
-- Total Orders Placed: Total count of orders (order_id).
-- Total Revenue Generated: Sum of sales amount (sales).
-- Average Sales per Order: Mean sales value rounded to 2 decimal places.
-- Management wants to include ALL registered customers (even those with 0 orders),
-- but wants to filter out non-active customer accounts generating total revenue under $500 using the HAVING clause.

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using LEFT JOIN, GROUP BY, aggregate functions (SUM, COUNT, AVG), and HAVING:
-- Select c.customer_id, c.customer_name, and c.state.
-- Compute total_orders: COUNT(s.order_id) (Notice: count s.order_id instead of *!).
-- Compute total_revenue: ROUND(COALESCE(SUM(s.sales), 0), 2).
-- Compute avg_order_value: ROUND(COALESCE(AVG(s.sales), 0), 2).
-- Join customers (alias c) as the left table with sales (alias s) as the right table on c.customer_id = s.customer_id.
-- Group by c.customer_id, c.customer_name, c.state.
-- Filter aggregated results using HAVING total_revenue >= 500.
-- 📋 Execution Instructions:
-- Sort the results in descending order of total_revenue (ORDER BY total_revenue DESC).
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    c.customer_id,
    c.customer_name,
    c.state,
    COUNT(s.order_id) AS total_orders,
    ROUND(COALESCE(SUM(s.sales), 0), 2) AS total_revenue,
    ROUND(COALESCE(AVG(s.sales), 0), 2) AS avg_order_value
FROM customers c
LEFT JOIN sales s 
    ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id,
    c.customer_name,
    c.state
HAVING total_revenue >= 500
ORDER BY total_revenue DESC
LIMIT 10;


-- Question 56 (SELF JOIN - Intermediate Level)
-- 📝 Scenario:
-- The customer retention team wants to analyze repeat purchasing behavior. They want to find pairs of separate orders placed by the same customer on different dates, so they can calculate the timeline between subsequent purchases.
-- To achieve this, you need to join the sales table to itself (aliasing one instance as s1 and the other as s2).
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a SELF JOIN on the sales table:
-- Select s1.customer_id, s1.customer_name, s1.order_id AS initial_order_id, s1.order_date AS initial_order_date, s2.order_id AS subsequent_order_id, and s2.order_date AS subsequent_order_date.
-- Join sales s1 with sales s2 on:
-- Same customer: s1.customer_id = s2.customer_id
-- Subsequent order date: s1.order_date < s2.order_date
-- Sort results by s1.customer_id ASC and s1.order_date ASC.
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    s1.customer_id,
    s1.customer_name,
    s1.order_id AS initial_order_id,
    s1.order_date AS initial_order_date,
    s2.order_id AS subsequent_order_id,
    s2.order_date AS subsequent_order_date
FROM sales s1
INNER JOIN sales s2 
    ON s1.customer_id = s2.customer_id
   AND s1.order_date < s2.order_date
ORDER BY 
    s1.customer_id ASC, 
    s1.order_date ASC
LIMIT 10;

-- ADVANCED LEVEL--
-- Question 57 (Non-EQUI JOIN & Range Matching - Advanced Level)
-- 📝 Scenario:
-- The business ops team wants to audit order frequency timing for high-value customers. They want to identify pairs of orders placed by the same customer where the second order was placed within 30 days after the first order, and where the second order's sales amount was higher than the first order's sales amount (indicating order value growth).
-- Because you are comparing rows based on date ranges (BETWEEN / <=) and value conditions (>), you must write a Non-EQUI SELF JOIN.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a Non-EQUI SELF JOIN on the sales table:
-- Select:
-- s1.customer_id
-- s1.customer_name
-- s1.order_id AS primary_order_id
-- s1.order_date AS primary_order_date
-- s1.sales AS primary_sales
-- s2.order_id AS upsell_order_id
-- s2.order_date AS upsell_order_date
-- s2.sales AS upsell_sales
-- Join sales s1 with sales s2 on:
-- Same customer: s1.customer_id = s2.customer_id
-- Order 2 occurs strictly after Order 1, but within 30 days:
-- s2.order_date > s1.order_date AND s2.order_date <= DATEDIFF_OR_ADD_30_DAYS (In standard SQL/MySQL: s2.order_date > s1.order_date AND s2.order_date <= DATE_ADD(s1.order_date, INTERVAL 30 DAY)).
-- Order 2 sales value is higher than Order 1 sales value: s2.sales > s1.sales
-- Sort results by s1.customer_id ASC and s1.order_date ASC.
-- Limit the final output to 10 rows (LIMIT 10).\
SELECT 
    s1.customer_id,
    s1.customer_name,
    s1.order_id AS primary_order_id,
    s1.order_date AS primary_order_date,
    s1.sales AS primary_sales,
    s2.order_id AS upsell_order_id,
    s2.order_date AS upsell_order_date,
    s2.sales AS upsell_sales
FROM sales s1
INNER JOIN sales s2 
    ON s1.customer_id = s2.customer_id
   AND s2.order_date > s1.order_date
   AND s2.order_date <= DATE_ADD(s1.order_date, INTERVAL 30 DAY)
   AND s2.sales > s1.sales
ORDER BY 
    s1.customer_id ASC, 
    s1.order_date ASC
LIMIT 10;

-- Here is Question 58 (Q58), the 2nd Advanced Level question for Topic 05: Joins & Set Operations.
-- This question focuses on CROSS JOIN (Cartesian Product) and its crucial real-world application in Data Analytics: generating complete combination matrices (e.g., ensuring every product category is paired with every region, even if zero sales occurred, so that report gaps can be identified).
-- 🔴 Topic 05: Joins & Set Operations
-- 🇬🇧 English: Topic 5 - Question 58 (CROSS JOIN & Cartesian Matrix Generation - Advanced Level)
-- 📝 Scenario:
-- The business intelligence team is building a executive matrix dashboard showing sales across every combination of Product Category and Sales Region.
-- When using a standard INNER JOIN or GROUP BY, regions with zero sales for a particular category get dropped from the report output. To build a complete grid where every category is explicitly mapped against every region (even if revenue is $0.00), you must first generate a full Cartesian product of unique categories and regions using a CROSS JOIN, then LEFT JOIN the aggregated sales data.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CROSS JOIN and a LEFT JOIN:
-- Select distinct product categories from sales (aliased as cat) and distinct regions from customers (aliased as reg).
-- CROSS JOIN these distinct categories and regions to form the master grid.
-- LEFT JOIN the sales table (s) on cat.category = s.category AND reg.region = s.region.
-- Display:
-- cat.category
-- reg.region
-- total_sales: ROUND(COALESCE(SUM(s.sales), 0), 2)
-- total_orders: COUNT(s.order_id)
-- Group by cat.category and reg.region.
-- Sort by cat.category ASC and reg.region ASC.

SELECT 
    cat.category,
    reg.region,
    ROUND(COALESCE(SUM(s.sales), 0), 2) AS total_sales,
    COUNT(s.order_id) AS total_orders
FROM (SELECT DISTINCT category FROM sales) cat
CROSS JOIN (SELECT DISTINCT region FROM customers) reg
LEFT JOIN sales s 
    ON cat.category = s.category 
   AND reg.region = s.region
GROUP BY 
    cat.category,
    reg.region
ORDER BY 
    cat.category ASC, 
    reg.region ASC;
    
-- Question 59 (Set Operations & Dataset Reconciliation - Advanced Level)
-- 📝 Scenario:
-- The data governance team needs to categorize our entire customer base into two distinct lists for an upcoming marketing campaign:
-- Active Buyers: Customers who exist in the customers table and have placed at least one order in the sales table.
-- Unmapped/Guest Customers: Orders logged in sales under guest accounts that do not exist in the customers table.
-- Management wants a single consolidated report that labels each customer/record with their category ('Active Customer' vs 'Unmapped Guest Order') using set combining techniques (UNION ALL).
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query combining two dataset queries using UNION ALL:
-- Query 1 (Active Customers): - Select c.customer_id, c.customer_name, and a static label 'Active Customer' AS customer_status.
-- Join customers c and sales s on c.customer_id = s.customer_id.
-- Select DISTINCT customer records so each customer appears only once in this segment.
-- Set Operator: Combine using UNION ALL.
-- Query 2 (Unmapped Guest Orders):
-- Select s.customer_id, s.customer_name, and a static label 'Unmapped Guest Order' AS customer_status.
-- Perform a LEFT JOIN from sales s to customers c on s.customer_id = c.customer_id.
-- Filter using WHERE c.customer_id IS NULL.
-- Select DISTINCT records so each unique guest ID appears once.
-- Sort the unified result set by customer_status ASC and customer_id ASC.

SELECT DISTINCT 
    c.customer_id,
    c.customer_name,
    'Active Customer' AS customer_status
FROM customers c
INNER JOIN sales s 
    ON c.customer_id = s.customer_id

UNION ALL

SELECT DISTINCT 
    s.customer_id,
    s.customer_name,
    'Unmapped Guest Order' AS customer_status
FROM sales s
LEFT JOIN customers c 
    ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL

ORDER BY 
    customer_status ASC, 
    customer_id ASC;
    
-- END OF MODULE -- 
