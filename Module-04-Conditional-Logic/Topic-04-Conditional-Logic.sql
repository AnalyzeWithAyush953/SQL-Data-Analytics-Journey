-- MODULE D (Conditional Logic) --
-- 📝 Scenario:
-- The customer service and ops team wants to categorize profit margins for each transaction row in the sales table to quickly identify order status. Management needs a simple string label assigned to each transaction based on its profit amount:

-- Profitable: Orders where profit > 0.

-- Loss: Orders where profit < 0.

-- Break-Even: Orders where profit = 0.

-- Your Task:Write a clean SQL query using a basic CASE WHEN statement to create a new derived column named profit_status along with standard order details from the sales table:Retrieve order_id, sales, profit.
-- Create the profit_status column using CASE WHEN:If profit > 0 $\rightarrow$ 'Profitable'If profit < 0 $\rightarrow$ 'Loss'Otherwise $\rightarrow$ 'Break-Even'📋 Execution 
-- Instructions:Apply the conditional logic at the row level (no GROUP BY required for this question)
-- .Alias the resulting calculated column strictly as profit_status.Limit output to the first 10 rows (LIMIT 10) for a quick inspection.

SELECT 
    order_id,
    sales,
    profit,
    CASE 
        WHEN profit > 0 THEN 'Profitable'
        WHEN profit < 0 THEN 'Loss'
        ELSE 'Break-Even'
    END AS profit_status
FROM sales
LIMIT 10;

-- Topic 4 - Question 42 (Conditional Logic - Beginner Level)
-- 📝 Scenario:The inventory and operations management team wants to group product categories into broader, high-level business departments in the sales table for supply-chain reporting.
--  They want every item mapped as follows:Technology category $\rightarrow$ Tech DepartmentFurniture category $\rightarrow$ Home & Office DepartmentOffice Supplies category $\rightarrow$ General Supplies DepartmentAny other value $\rightarrow$ Other Department
--  🎯 Your Task:Write a clean, production-grade SQL query using a Simple CASE statement (testing direct column equality) to create a new column named department_name:Select order_id, category, sub_category, and sales.Create department_name 
--  using simple string matching on category:'Technology' $\rightarrow$ 'Tech Department''Furniture' $\rightarrow$ 'Home & Office Department''Office Supplies' $\rightarrow$ 'General Supplies Department'Fallback $\rightarrow$ 'Other Department'
--  📋 Execution Instructions:Use Simple CASE category WHEN ... syntax.Alias the calculated field strictly as department_name.Limit the final output to 10 rows (LIMIT 10).

SELECT 
    order_id,
    category,
    sub_category,
    sales,
    CASE category
        WHEN 'Technology' THEN 'Tech Department'
        WHEN 'Furniture' THEN 'Home & Office Department'
        WHEN 'Office Supplies' THEN 'General Supplies Department'
        ELSE 'Other Department'
    END AS department_name
FROM sales
LIMIT 10;

-- Topic 4 - Question 43 (Conditional Logic - Beginner Level)
-- 📝 Scenario:
-- The logistics team is generating shipping manifests from the sales table.
--  In the raw database, some orders are missing a postal_code entry (NULL), while others are missing a ship_mode (NULL).
-- To prevent automated mailing systems from failing, management wants a clean report where:
-- Any missing postal_code is safely replaced with '00000'.
-- Any missing ship_mode is safely replaced with 'Standard Class'.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using COALESCE() to handle missing string and numeric/text fields:
-- Select order_id, customer_name, ship_mode, and postal_code.
-- Create clean_ship_mode: Use COALESCE(ship_mode, 'Standard Class').
-- Create clean_postal_code: Use COALESCE(postal_code, '00000').
-- 📋 Execution Instructions:
-- Alias the derived fields strictly as clean_ship_mode and clean_postal_code.
-- Filter the result to show rows where either ship_mode IS NULL OR postal_code IS NULL so you can verify that missing values are replaced correctly.
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    order_id,
    customer_name,
    ship_mode,
    postal_code,
    COALESCE(ship_mode, 'Standard Class') AS clean_ship_mode,
    COALESCE(postal_code, '00000') AS clean_postal_code
FROM sales
WHERE ship_mode IS NULL OR postal_code IS NULL
LIMIT 10;

-- INTERMEDIATE LEVEL --  
-- Topic 4 - Question 44 (Conditional Logic - Intermediate Level)
-- 📝 Scenario:The logistics and executive operations team wants to assign a dynamic Priority Processing Flag (order_priority_tier) to every transaction row in the sales table based on shipping mode, sale amount, and profitability:Critical VIP:
--  Orders where ship_mode = 'Same Day' AND sales >= 500.High Priority: Orders where sales >= 1000 OR profit >= 200.Attention Required: Loss-making orders where profit < 0 (regardless of sales value).Standard Processing:
--  All other transactions.🎯 Your Task:Write a clean, production-grade SQL query using a multi-condition CASE WHEN block with AND and OR boolean operators to generate the order_priority_tier column:Retrieve order_id, ship_mode, sales, profit.
--  Construct the order_priority_tier derived column using CASE WHEN:ship_mode = 'Same Day' AND sales >= 500 $\rightarrow$ 'Critical VIP'sales >= 1000 OR profit >= 200 $\rightarrow$ 'High Priority'profit < 0 $\rightarrow$ 'Attention Required'Fallback $\rightarrow$ 'Standard Processing'📋 
--  Execution Instructions:Pay strict attention to the sequential top-to-bottom order of the WHEN evaluation branches.Alias the resulting column strictly as order_priority_tier
--  .Sort results so that 'Critical VIP' orders appear at the top, followed by 'High Priority' (ORDER BY sales DESC).Limit the output to 10 rows (LIMIT 10).
SELECT 
    order_id,
    ship_mode,
    sales,
    profit,
    CASE 
        WHEN ship_mode = 'Same Day' AND sales >= 500 THEN 'Critical VIP'
        WHEN sales >= 1000 OR profit >= 200 THEN 'High Priority'
        WHEN profit < 0 THEN 'Attention Required'
        ELSE 'Standard Processing'
    END AS order_priority_tier
FROM sales
ORDER BY sales DESC
LIMIT 10;

-- Question 45 (Conditional Logic - Intermediate Level)
-- 📝 Scenario:
-- The financial analysis team is computing the Profit Ratio (profit / sales) for each transaction in the sales table.
-- In raw transactional systems, some test orders or promotional items are logged with a sales value of 0 (sales = 0). If you attempt to divide profit by sales directly (profit / sales), SQL database engines will immediately crash with a Division by zero execution error!
-- Management wants a resilient query that calculates the profit margin percentage safely by converting 0 sales values to NULL prior to division using NULLIF(), and then substituting any resulting NULL margin with 0.00 using COALESCE().
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using NULLIF() and COALESCE() to calculate the profit margin ratio:
-- Select order_id, sales, and profit.
-- Compute safe_profit_margin_pct:
-- Divide profit by NULLIF(sales, 0).
-- Multiply the result by 100 to convert to a percentage.
-- Wrap the division inside COALESCE(..., 0) to convert any division-by-zero outputs safely to 0.
-- Round the final percentage cleanly to 2 decimal places using ROUND().
-- 📋 Execution Instructions:
-- Alias the calculated field strictly as safe_profit_margin_pct.
-- Sort results in ascending order of sales (ORDER BY sales ASC) to inspect low/zero sales records first.
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    order_id,
    sales,
    profit,
    ROUND(COALESCE((profit / NULLIF(sales, 0)) * 100, 0), 2) AS safe_profit_margin_pct
FROM sales
ORDER BY sales ASC
LIMIT 10;

-- Question 46 (Conditional Logic - Intermediate Level)
-- 📝 Scenario:
-- The customer data governance team is auditing the sales table prior to migrating customer contact records. In the raw dataset, the region column contains missing data stored in three different problematic forms:
-- Actual NULL values.
-- Empty string values ('').
-- Single space strings (' ').
-- If you use COALESCE(region, 'Unassigned Region') alone, empty strings ('') and spaces (' ') will not be replaced because they are non-NULL values!
-- Management wants a single clean query that converts both empty strings and whitespace-only strings into actual NULLs first, and then safely substitutes all missing records with 'Unassigned Region'.
-- 🎯 Your Task:
-- Write a clean, production-grade SQL query combining TRIM(), NULLIF(), and COALESCE() to generate a clean derived column named sanitized_region:
-- Select order_id, customer_name, and the raw region column.
-- Create sanitized_region:
-- First, trim whitespace using TRIM(region).
-- Next, convert empty strings to NULL using NULLIF(TRIM(region), '').
-- Finally, replace any resulting NULL with 'Unassigned Region' using COALESCE(..., 'Unassigned Region').

-- 📋 Execution Instructions:
-- Alias the sanitized column strictly as sanitized_region.
-- Filter the result in the WHERE clause to display rows where region IS NULL OR TRIM(region) = '' so you can verify that blank entries are cleaned properly.
-- Limit the final output to 10 rows (LIMIT 10).

SELECT 
    order_id,
    customer_name,
    region,
    COALESCE(NULLIF(TRIM(region), ''), 'Unassigned Region') AS sanitized_region
FROM sales
WHERE region IS NULL OR TRIM(region) = ''
LIMIT 10;

-- Advanced level question --
--  Question 47 (Conditional Logic - Advanced Level)
--  📝 Scenario:The sales incentive and strategy team wants to compute dynamic Commission Rates for order transactions in the sales table.
--  Commission structures depend on both product category and dollar amount in sales:Technology 
--  Category:If sales >= 1000 $\rightarrow$ 15% CommissionOtherwise $\rightarrow$ 10% CommissionFurniture 
--  Category:If sales >= 500 $\rightarrow$ 12% CommissionOtherwise $\rightarrow$ 8% CommissionAll 
--  Other Categories (Office Supplies, etc.)
--  :If sales >= 250 $\rightarrow$ 10% CommissionOtherwise $\rightarrow$ 5% CommissionManagement wants a single clean query that outputs order details,
--  the evaluated commission_pct_label, and the exact dollar amount commission_earned (calculated as sales * (commission_percentage / 100) rounded to 2 decimal places).
--  🎯 Your Task:Write a clean, production-grade SQL query using a Nested CASE WHEN statement (or equivalent multi-condition logic) to evaluate the commission_earned and commission_rate:Select order_id, category, sales.
--  Construct a Nested CASE WHEN block to derive commission_pct_label ('15%', '10%', '12%', '8%', '5%').Calculate commission_earned: Multiply sales by the corresponding numeric rate and round to 2 decimal places using ROUND().
--  📋 Execution Instructions:Alias fields strictly as commission_pct_label and commission_earned.Sort results in descending order of commission_earned (ORDER BY commission_earned DESC).Limit the final output to 10 rows (LIMIT 10).
SELECT 
    order_id,
    category,
    sales,
    CASE category
        WHEN 'Technology' THEN 
            CASE 
                WHEN sales >= 1000 THEN '15%'
                ELSE '10%'
            END
        WHEN 'Furniture' THEN 
            CASE 
                WHEN sales >= 500 THEN '12%'
                ELSE '8%'
            END
        ELSE 
            CASE 
                WHEN sales >= 250 THEN '10%'
                ELSE '5%'
            END
    END AS commission_pct_label,
    ROUND(
        sales * CASE category
            WHEN 'Technology' THEN IF(sales >= 1000, 0.15, 0.10)
            WHEN 'Furniture' THEN IF(sales >= 500, 0.12, 0.08)
            ELSE IF(sales >= 250, 0.10, 0.05)
        END, 
    2) AS commission_earned
FROM sales
ORDER BY commission_earned DESC
LIMIT 10;

-- Question 48 (Conditional Logic - Advanced Level)
-- 📝 Scenario:
-- The regional executive committee wants a single consolidated summary report analyzing discount impact across product categories in the sales table.
-- Instead of showing discounted orders and non-discounted orders across separate rows, management needs a single row per category showing:
-- Total Category Sales: Combined sales for all orders in that category.
-- Discounted Sales: Total sales for orders where discount > 0.
-- Full Price Sales: Total sales for orders where discount = 0 or discount IS NULL.
-- Discounted Order Count: Count of orders where a discount was applied (discount > 0).
-- Full Price Order Count: Count of orders sold at full price (discount = 0 or discount IS NULL).

-- 🎯 Your Task:
-- Write a clean, production-grade SQL query using SUM(CASE WHEN...) and COUNT(CASE WHEN...) to group the sales table by category and compute the 5 dynamic pivoted metrics:
-- Select category.
-- Calculate total_sales: ROUND(SUM(sales), 2).
-- Calculate discounted_sales: ROUND(SUM(CASE WHEN discount > 0 THEN sales ELSE 0 END), 2).
-- Calculate full_price_sales: ROUND(SUM(CASE WHEN COALESCE(discount, 0) = 0 THEN sales ELSE 0 END), 2).
-- Calculate discounted_orders: COUNT(CASE WHEN discount > 0 THEN 1 END).
-- Calculate full_price_orders: COUNT(CASE WHEN COALESCE(discount, 0) = 0 THEN 1 END).
-- 📋 Execution Instructions:
-- Group records by category using GROUP BY category.
-- Sort results in descending order of total_sales (ORDER BY total_sales DESC).

SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(CASE WHEN discount > 0 THEN sales ELSE 0 END), 2) AS discounted_sales,
    ROUND(SUM(CASE WHEN COALESCE(discount, 0) = 0 THEN sales ELSE 0 END), 2) AS full_price_sales,
    COUNT(CASE WHEN discount > 0 THEN 1 END) AS discounted_orders,
    COUNT(CASE WHEN COALESCE(discount, 0) = 0 THEN 1 END) AS full_price_orders
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- Topic 4 - Question 49 (Conditional Logic - Advanced Level)
-- 📝 Scenario:The executive reporting team is building a dynamic dashboard filter for the sales table. 
-- Instead of writing separate SQL queries for every possible sorting preference selected by end-users,
--  management wants a single query that sorts transactions dynamically based on a parameter 
--  logic:When sorting by Revenue ('by_sales'): Sort transactions by sales in descending order (highest sale first).
--  When sorting by Profitability ('by_profit'): Sort transactions by profit in descending order (highest profit first).
--  When sorting by Shipping Speed ('by_ship_mode'): Sort transactions priority-wise based on shipping speed:'Same Day' $\rightarrow$ Rank 1'First Class' $\rightarrow$ Rank 2'Second Class' $\rightarrow$ Rank 3'Standard Class' $\rightarrow$ Rank 4🎯 
--  Your Task:Write a clean, production-grade SQL query using a CASE WHEN block inside the ORDER BY clause to implement dynamic sorting:Select order_id, customer_name, ship_mode, sales, and profit.
--  Simulate sorting by Shipping Speed ('by_ship_mode') using a CASE WHEN statement inside ORDER BY that assigns custom numeric rank weights (1, 2, 3, 4) to ship_mode.Secondary sort: Break ties in shipping speed by sorting sales in descending order.📋
-- Execution Instructions:Embed the conditional logic directly inside the ORDER BY clause.Limit the final output to 10 rows (LIMIT 10).

SELECT 
    order_id,
    customer_name,
    ship_mode,
    sales,
    profit
FROM sales
ORDER BY 
    CASE ship_mode
        WHEN 'Same Day' THEN 1
        WHEN 'First Class' THEN 2
        WHEN 'Second Class' THEN 3
        WHEN 'Standard Class' THEN 4
        ELSE 5
    END ASC,
    sales DESC
LIMIT 10;
