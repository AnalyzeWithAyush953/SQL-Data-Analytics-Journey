Use superstore_sales;
-- TOPIC 8 --
-- Advanced Aggregations -- 
-- Topic 08: Advanced Aggregations (GROUP BY ROLLUP, CUBE, GROUPING SETS, GROUPING() --
-- Question 78 (GROUP BY ... WITH ROLLUP - Beginner Level)
-- 📝 Scenario:
-- The executive leadership team requires a hierarchical sales report for quarterly review. Instead of running separate queries for region-level, category-level, and company-wide totals, they want a single consolidated summary report.
-- The report must calculate total sales and total profit broken down by region and category, but it must also dynamically generate subtotals for each region as well as a overall Grand Total across all regions and categories.
-- To achieve this in a single query pass without joining multiple GROUP BY outputs using UNION ALL, you must use GROUP BY region, category WITH ROLLUP.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using WITH ROLLUP:
-- Select region, category, ROUND(SUM(sales), 2) AS total_sales, and ROUND(SUM(profit), 2) AS total_profit.
-- Group rows using: GROUP BY region, category WITH ROLLUP.
-- Sort output logically to keep subtotals adjacent to their respective groups.
-- Limit the preview output to 12 rows (LIMIT 12).

SELECT 
    region,
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY 
    region, 
    category WITH ROLLUP
LIMIT 12;

-- Question 79 (Subtotal & Grand Total Labeling using GROUPING() - Beginner Level)
-- 📝 Scenario:
-- The finance team reviewed the ROLLUP report from Q78, but they complained that seeing raw NULL values for subtotals and grand totals looks un professional and creates confusion in executive dashboards
-- (since users can't distinguish between a missing category name and a subtotal row).
-- Management wants you to refine the query using the GROUPING() function.
-- When category is aggregated into a regional subtotal, display 'All Categories' (or 'Region Subtotal').
-- When both region and category are aggregated into the company-wide total, display 'All Regions' for region and 'Grand Total' for category.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using GROUPING() and IF() (or CASE WHEN):
-- Select a formatted region column:
-- IF(GROUPING(region) = 1, 'All Regions', region) AS region.
-- Select a formatted category column:
-- IF(GROUPING(category) = 1, 'All Categories', category) AS category.
-- Aggregate total_sales (ROUND(SUM(sales), 2)) and total_profit (ROUND(SUM(profit), 2)).
-- Group using: GROUP BY region, category WITH ROLLUP.
-- Limit the output to 12 rows (LIMIT 12).

SELECT 
    IF(GROUPING(region) = 1, 'All Regions', region) AS region,
    IF(GROUPING(category) = 1, 'All Categories', category) AS category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY 
    region, 
    category WITH ROLLUP
LIMIT 12;

-- INTERMEDIATE LEVEL --
-- Question 80 (Multi-Level Date Hierarchy Rollups - Intermediate Level)
-- 📝 Scenario:
-- The executive financial planning team needs a multi-level time-series report showing sales performance aggregated across
-- three date granularities:
-- sales_year: YEAR(order_date)
-- sales_quarter: QUARTER(order_date)
-- sales_month: MONTH(order_date)
-- The report must display:
-- Granular monthly totals.
-- Subtotals at the end of each Quarter.
-- Subtotals at the end of each Year.
-- A final company-wide Grand Total across all years.
-- To prevent raw NULL values on subtotal rows and maintain executive presentation standards, you must use the GROUPING() function to dynamically label subtotal rows as 'All Years', 'Quarterly Total', and 'Monthly Total'.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using GROUP BY ... WITH ROLLUP and GROUPING():
-- Format sales_year:
-- IF(GROUPING(YEAR(order_date)) = 1, 'All Years', CAST(YEAR(order_date) AS CHAR)) AS sales_year.
-- Format sales_quarter:
-- IF(GROUPING(QUARTER(order_date)) = 1, 'Quarterly Total', CAST(QUARTER(order_date) AS CHAR)) AS sales_quarter.
-- Format sales_month:
-- IF(GROUPING(MONTH(order_date)) = 1, 'Monthly Total', CAST(MONTH(order_date) AS CHAR)) AS sales_month.
-- Aggregate total_revenue: ROUND(SUM(sales), 2).
-- Group using: GROUP BY YEAR(order_date), QUARTER(order_date), MONTH(order_date) WITH ROLLUP.
-- Limit the output preview to 15 rows (LIMIT 15).

WITH sales_with_date_parts AS (
    SELECT 
        YEAR(order_date) AS yr,
        QUARTER(order_date) AS qtr,
        MONTH(order_date) AS mth,
        sales
    FROM sales
)
SELECT 
    IF(GROUPING(yr) = 1, 'All Years', CAST(yr AS CHAR)) AS sales_year,
    IF(GROUPING(qtr) = 1, 'Quarterly Total', CAST(qtr AS CHAR)) AS sales_quarter,
    IF(GROUPING(mth) = 1, 'Monthly Total', CAST(mth AS CHAR)) AS sales_month,
    ROUND(SUM(sales), 2) AS total_revenue
FROM sales_with_date_parts
GROUP BY 
    yr, 
    qtr, 
    mth WITH ROLLUP
LIMIT 15;


-- ADVANCED AGGERGATION -- 

-- Question 81 (Simulating GROUPING SETS / CUBE via UNION ALL - Advanced Level)
-- 📝 Scenario:
-- The executive sales team wants a multi-dimensional cross-tabulation matrix report. Instead of a single hierarchy (like Region -> Category), they want to compare aggregates across 4 distinct grouping dimensions simultaneously in a single dataset:
-- Group 1 (Region + Category): Granular breakdown.
-- Group 2 (Region Total): Aggregated across all categories for each region.
-- Group 3 (Category Total): Aggregated across all regions for each category.
-- Group 4 (Grand Total): Overall platform performance across all regions and categories.
-- Since MySQL lacks native GROUP BY CUBE(region, category) syntax, write a production query using a CTE and UNION ALL to synthesize all 4 grouping sets into one clean output.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using a CTE and UNION ALL:
-- Branch 1 (Region + Category):
-- Select region, category, ROUND(SUM(sales), 2) AS total_sales, ROUND(SUM(profit), 2) AS total_profit, and tag 1 AS grouping_level.
-- Branch 2 (Region Subtotal):
-- Select region, 'All Categories' AS category, ROUND(SUM(sales), 2), ROUND(SUM(profit), 2), and tag 2 AS grouping_level.
-- Branch 3 (Category Subtotal):
-- Select 'All Regions' AS region, category, ROUND(SUM(sales), 2), ROUND(SUM(profit), 2), and tag 3 AS grouping_level.
-- Branch 4 (Grand Total):
-- Select 'All Regions' AS region, 'All Categories' AS category, ROUND(SUM(sales), 2), ROUND(SUM(profit), 2), and tag 4 AS grouping_level
-- Combine all 4 branches using UNION ALL.
-- Sort output by grouping_level ASC, region ASC, category ASC.
-- Limit output preview to 15 rows (LIMIT 15).

WITH grouping_matrix AS (
    -- Grouping Set 1: Region + Category (Granular)
    SELECT 
        region,
        category,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        1 AS grouping_level
    FROM sales
    GROUP BY region, category

    UNION ALL

    -- Grouping Set 2: Region Totals (All Categories)
    SELECT 
        region,
        'All Categories' AS category,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        2 AS grouping_level
    FROM sales
    GROUP BY region

    UNION ALL

    -- Grouping Set 3: Category Totals (All Regions)
    SELECT 
        'All Regions' AS region,
        category,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        3 AS grouping_level
    FROM sales
    GROUP BY category

    UNION ALL

    -- Grouping Set 4: Grand Total
    SELECT 
        'All Regions' AS region,
        'All Categories' AS category,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        4 AS grouping_level
    FROM sales
)
SELECT 
    region,
    category,
    total_sales,
    total_profit,
    grouping_level
FROM grouping_matrix
ORDER BY 
    grouping_level ASC, 
    region ASC, 
    category ASC
LIMIT 15;
