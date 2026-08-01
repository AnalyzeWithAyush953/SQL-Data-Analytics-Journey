use superstore_sales
-- WINDOW FUNCTIONS--
-- BEGINNER LEVEL-- 
-- Question 69 (ROW_NUMBER() with PARTITION BY - Beginner Level)
-- 📝 Scenario:
-- The customer analytics team wants to track customer order histories sequentially. They need to assign a sequential integer row number (1, 2, 3...) to every order placed by each customer, ordered from their earliest purchase date to their most recent purchase date.
-- Unlike GROUP BY (which aggregates and collapses multiple orders into a single row), management wants to keep every individual transaction row intact, while appending a dynamic sequence number calculated per customer.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...):
-- Select customer_id, customer_name, order_id, order_date, and sales.
-- Compute purchase_sequence:
-- ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date ASC, order_id ASC).
-- Filter or limit for preview: Filter for customers with multiple orders or order by customer_id ASC, order_date ASC.
-- Limit the final output to 10 rows (LIMIT 10)

SELECT customer_id,customer_name,order_id,order_date,sales,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id 
        ORDER BY order_date ASC, order_id ASC
    ) AS purchase_sequence
FROM sales
ORDER BY 
    customer_id ASC, 
    order_date ASC
LIMIT 10;

-- Question 70 (ROW_NUMBER() vs RANK() vs DENSE_RANK() - Beginner Level)
-- 📝 Scenario:
-- The executive sales leadership wants to establish a regional product performance leaderboard. 
-- They want to rank product categories within each region based on their total sales revenue from highest to lowest.
-- Because two or more categories in a region might generate the exact same sales amount (a tie),
-- leadership wants a single audit report comparing all three ranking functions (ROW_NUMBER(), RANK(), and DENSE_RANK()) side-by-side to observe how each handles identical sales values.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE and Window Functions:
-- Define a CTE category_sales_summary:
-- Aggregate the sales table grouped by region and category.
-- Calculate total_sales: ROUND(SUM(sales), 2).
-- In the main query, select region, category, and total_sales.
-- Compute three side-by-side ranking columns partitioned by region and ordered by total_sales DESC:
-- row_num: ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_sales DESC)
-- rank_num: RANK() OVER (PARTITION BY region ORDER BY total_sales DESC)
-- dense_rank_num: DENSE_RANK() OVER (PARTITION BY region ORDER BY total_sales DESC)
-- Sort by region ASC and total_sales DESC.
-- Limit the final output to 10 rows (LIMIT 10).

WITH category_sales_summary AS (
    SELECT 
        region,
        category,
        ROUND(SUM(sales), 2) AS total_sales
    FROM sales
    GROUP BY 
        region,
        category
)
SELECT 
    region,
    category,
    total_sales,
    ROW_NUMBER() OVER (
        PARTITION BY region 
        ORDER BY total_sales DESC
    ) AS row_num,
    RANK() OVER (
        PARTITION BY region 
        ORDER BY total_sales DESC
    ) AS rank_num,
    DENSE_RANK() OVER (
        PARTITION BY region 
        ORDER BY total_sales DESC
    ) AS dense_rank_num
FROM category_sales_summary
ORDER BY 
    region ASC, 
    total_sales DESC
LIMIT 10;

-- Topic 7 - Question 71 (Top-N Filtering per Group using CTE - Beginner Level)
-- 📝 Scenario:
-- The regional operations leadership needs to reward top-performing clients.
-- They want a report showing the Top 3 highest-spending customers in EACH region.
-- Because you cannot apply a WHERE filter directly on a Window Function in the same SELECT pass,
-- you must compute the rank using DENSE_RANK() inside a CTE, and then filter for rank_num <= 3 in the outer query.

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE and DENSE_RANK():
-- Define a CTE customer_regional_spend:
-- Aggregate the sales table grouped by region, customer_id, and customer_name.
-- Calculate total_spend: ROUND(SUM(sales), 2).
-- Compute regional_rank: DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC).
-- In the main query:
-- Select region, customer_id, customer_name, total_spend, and regional_rank.
-- Filter using WHERE regional_rank <= 3.
-- Sort by region ASC and regional_rank ASC.
-- Limit the final output to 12 rows (LIMIT 12).`

WITH customer_regional_spend AS (
    SELECT 
        region,
        customer_id,
        customer_name,
        ROUND(SUM(sales), 2) AS total_spend,
        DENSE_RANK() OVER (
            PARTITION BY region 
            ORDER BY SUM(sales) DESC
        ) AS regional_rank
    FROM sales
    GROUP BY 
        region,
        customer_id,
        customer_name
)
SELECT 
    region,
    customer_id,
    customer_name,
    total_spend,
    regional_rank
FROM customer_regional_spend
WHERE regional_rank <= 3
ORDER BY 
    region ASC, 
    regional_rank ASC
LIMIT 12;


-- INTERMEDIATE LEVEL--
-- 🟡 Topic 07: Window Functions
-- - Question 72 (Offset Function LAG() for Order Interval Analysis - Intermediate Level)
-- 📝 Scenario:
-- The customer retention team wants to measure buying velocity and repeat purchase behavior. For every order placed by a customer, they want to see:
-- The current order date.
-- The previous order date placed by the same customer.
-- The days elapsed between the current order and their previous order (DATEDIFF).
-- To achieve this without self-joining the table on complex inequality conditions, you must use the LAG() window function.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using LAG() OVER (PARTITION BY ... ORDER BY ...):
-- Select customer_id, customer_name, order_id, order_date, and sales.
-- Compute prev_order_date:
-- LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC).
-- Compute days_since_last_order:
-- DATEDIFF(order_date, LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC)).
-- Filter or order by customer_id ASC, order_date ASC.
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    customer_id,
    customer_name,
    order_id,
    order_date,
    sales,
    LAG(order_date, 1) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date ASC
    ) AS prev_order_date,
    DATEDIFF(
        order_date, 
        LAG(order_date, 1) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date ASC
        )
    ) AS days_since_last_order
FROM sales
ORDER BY 
    customer_id ASC, 
    order_date ASC
LIMIT 10;

-- Question 73 (Offset Function LEAD() & Year-over-Year Growth Analysis - Intermediate Level)
-- 📝 Scenario:
-- The executive finance team is analyzing annual category growth trends. They need a summary report listing total sales revenue per product category by year, alongside:
-- The subsequent year's sales revenue for that same category (using LEAD()).
-- The Year-over-Year (YoY) revenue difference (Next Year Sales - Current Year Sales).
-- The YoY percentage growth rate (((Next Year - Current Year) / Current Year) * 100).
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE and LEAD():
-- Define a CTE yearly_category_sales:
-- Group sales by category and YEAR(order_date) (aliased as sales_year).
-- Calculate current_year_sales: ROUND(SUM(sales), 2).
-- Define a second CTE yearly_lead_summary:
-- Select category, sales_year, and current_year_sales.
-- Compute next_year_sales:
-- LEAD(current_year_sales, 1) OVER (PARTITION BY category ORDER BY sales_year ASC).
-- In the main query:
-- Select category, sales_year, current_year_sales, and next_year_sales.
-- Calculate yoy_revenue_diff: ROUND(next_year_sales - current_year_sales, 2).
-- Calculate yoy_growth_pct: ROUND(((next_year_sales - current_year_sales) / current_year_sales) * 100, 2).
-- Sort by category ASC, sales_year ASC.
-- Limit the output to 10 rows (LIMIT 10).

WITH yearly_category_sales AS (
    SELECT 
        category,
        YEAR(order_date) AS sales_year,
        ROUND(SUM(sales), 2) AS current_year_sales
    FROM sales
    GROUP BY 
        category,
        YEAR(order_date)
),
yearly_lead_summary AS (
    SELECT 
        category,
        sales_year,
        current_year_sales,
        LEAD(current_year_sales, 1) OVER (
            PARTITION BY category 
            ORDER BY sales_year ASC
        ) AS next_year_sales
    FROM yearly_category_sales
)
SELECT 
    category,
    sales_year,
    current_year_sales,
    next_year_sales,
    ROUND(next_year_sales - current_year_sales, 2) AS yoy_revenue_diff,
    ROUND(((next_year_sales - current_year_sales) / current_year_sales) * 100, 2) AS yoy_growth_pct
FROM yearly_lead_summary
ORDER BY 
    category ASC, 
    sales_year ASC
LIMIT 10;


-- English: Topic 7 - Question 74 (Cumulative Sum / Running Total - Intermediate Level)
-- 📝 Scenario:
-- The finance team wants to track cumulative monthly revenue progression throughout each fiscal year.
-- They need a report listing monthly total revenue for each year, 
-- along with a running total (cumulative sales) that resets at the beginning of each calendar year (PARTITION BY YEAR) and accumulates chronologically across the months (ORDER BY MONTH).
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE and an aggregational window function SUM() OVER (...):
-- Define a CTE monthly_sales_summary:
-- Group sales by YEAR(order_date) (aliased as sales_year) and MONTH(order_date) (aliased as sales_month).
-- Calculate monthly_revenue: ROUND(SUM(sales), 2).
-- In the main query:
-- Select sales_year, sales_month, and monthly_revenue.
-- Calculate running_total_revenue:
-- SUM(monthly_revenue) OVER (PARTITION BY sales_year ORDER BY sales_month ASC).
-- Sort output by sales_year ASC, sales_month ASC.
-- Limit the final output to 12 rows (LIMIT 12).

WITH monthly_sales_summary AS (
    SELECT 
        YEAR(order_date) AS sales_year,
        MONTH(order_date) AS sales_month,
        ROUND(SUM(sales), 2) AS monthly_revenue
    FROM sales
    GROUP BY 
        YEAR(order_date),
        MONTH(order_date)
)
SELECT 
    sales_year,
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        PARTITION BY sales_year 
        ORDER BY sales_month ASC
    ) AS running_total_revenue
FROM monthly_sales_summary
ORDER BY 
    sales_year ASC, 
    sales_month ASC
LIMIT 12;

-- ADVANCED LEVEL --
-- Topic 7 - Question 75 (Moving Averages & Custom Window Frames - Advanced Level)
-- 📝 Scenario:
-- The business intelligence team is analyzing revenue volatility. Standard daily or monthly sales spikes (like weekend promotions) make long-term trend lines noisy.
-- To smooth out these fluctuations, the analytics director wants a 3-Month Moving Average 
-- (3-Month Rolling Average) of monthly revenue for each product category.
-- For any given month, the moving average must be computed as the average revenue of the current month plus the two preceding months
-- (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW).

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE and a custom window frame specification:
-- Define a CTE monthly_category_sales:
-- Group sales by category, YEAR(order_date) (aliased as sales_year), and MONTH(order_date) (aliased as sales_month).
-- Compute monthly_revenue: ROUND(SUM(sales), 2).
-- In the main query:
-- Select category, sales_year, sales_month, and monthly_revenue.
-- Calculate moving_avg_3m:
-- ROUND(AVG(monthly_revenue) OVER (PARTITION BY category ORDER BY sales_year ASC, sales_month ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2).
-- Sort by category ASC, sales_year ASC, and sales_month ASC.
-- Limit the final output to 12 rows (LIMIT 12).

WITH monthly_category_sales AS (
    SELECT 
        category,
        YEAR(order_date) AS sales_year,
        MONTH(order_date) AS sales_month,
        ROUND(SUM(sales), 2) AS monthly_revenue
    FROM sales
    GROUP BY 
        category,
        YEAR(order_date),
        MONTH(order_date)
)
SELECT 
    category,
    sales_year,
    sales_month,
    monthly_revenue,
    ROUND(
        AVG(monthly_revenue) OVER (
            PARTITION BY category 
            ORDER BY sales_year ASC, sales_month ASC
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_3m
FROM monthly_category_sales
ORDER BY 
    category ASC, 
    sales_year ASC, 
    sales_month ASC
LIMIT 12;

-- Question 76 (Data Deduplication Pattern using ROW_NUMBER() - Advanced Level)
-- 📝 Scenario:
-- Due to a system sync error in the transaction pipeline, duplicate sales records were logged for certain customers on the same date for the same category.
-- The data engineering manager wants you to write an auditing query to identify and keep ONLY the single highest-value transaction (sales) per customer per date per category, while assigning duplicate rank tags to any secondary or redundant entries so they can be filtered out.
-- To solve this, you must construct a window partition across (customer_id, order_date, category), order transactions by sales DESC (and tie-breaker order_id DESC), and keep records where row_num = 1.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE and ROW_NUMBER():
-- Define a CTE deduplicated_sales_audit:
-- Select order_id, order_date, customer_id, customer_name, category, and sales.
-- Compute dedup_rank:
-- ROW_NUMBER() OVER (PARTITION BY customer_id, order_date, category ORDER BY sales DESC, order_id DESC).
-- In the main query:
-- Select order_id, order_date, customer_id, customer_name, category, sales, and dedup_rank.
-- Filter using WHERE dedup_rank = 1 to return strictly unique, non-duplicate clean records.
-- Sort output by customer_id ASC, order_date DESC.
-- Limit the final output to 10 rows (LIMIT 10).

WITH deduplicated_sales_audit AS (
    SELECT 
        order_id,
        order_date,
        customer_id,
        customer_name,
        category,
        sales,
        ROW_NUMBER() OVER (
            PARTITION BY 
                customer_id, 
                order_date, 
                category 
            ORDER BY 
                sales DESC, 
                order_id DESC
        ) AS dedup_rank
    FROM sales
)
SELECT 
    order_id,
    order_date,
    customer_id,
    customer_name,
    category,
    sales,
    dedup_rank
FROM deduplicated_sales_audit
WHERE dedup_rank = 1
ORDER BY 
    customer_id ASC, 
    order_date DESC
LIMIT 10;

-- Question 77 (NTILE() & PERCENT_RANK() for Customer Value Segmentation - Advanced Level)
-- 📝 Scenario:
-- The customer growth team wants to categorize registered customer profiles into 4 equal quartile tiers based on their total historical spend in the sales table:
-- Quartile 1: Top 25% High-Value VIP Customers
-- Quartile 2: Tier-2 Mid-High Customers
-- Quartile 3: Tier-3 Mid-Low Customers
-- Quartile 4: Tier-4 Low-Value / At-Risk Customers
-- Additionally, management wants to see the exact relative percentile rank (PERCENT_RANK()) for each customer on a scale from 0.00 (0th percentile / lowest) to 1.00 (100th percentile / highest).
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE and distribution window functions:
-- Define a CTE customer_spend_summary:
-- Aggregate sales grouped by customer_id and customer_name.
-- Compute total_spend: ROUND(SUM(sales), 2).
-- In the main query:
-- Select customer_id, customer_name, and total_spend.
-- Calculate spend_quartile:
-- NTILE(4) OVER (ORDER BY total_spend DESC).
-- Calculate percentile_rank:
-- ROUND(PERCENT_RANK() OVER (ORDER BY total_spend ASC), 4).
-- Sort by total_spend DESC.
-- Limit the final output to 12 rows (LIMIT 12).

WITH customer_spend_summary AS (
    SELECT 
        customer_id,
        customer_name,
        ROUND(SUM(sales), 2) AS total_spend
    FROM sales
    GROUP BY 
        customer_id,
        customer_name
)
SELECT 
    customer_id,
    customer_name,
    total_spend,
    NTILE(4) OVER (
        ORDER BY total_spend DESC
    ) AS spend_quartile,
    ROUND(
        PERCENT_RANK() OVER (
            ORDER BY total_spend ASC
        ), 4
    ) AS percentile_rank
FROM customer_spend_summary
ORDER BY 
    total_spend DESC
LIMIT 12;
