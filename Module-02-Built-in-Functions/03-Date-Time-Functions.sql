-- DATE AND TIME FUNCTION --
-- Beginner Level (Q22 – Q24): Date Extraction (YEAR, MONTH, DAY, DAYNAME, MONTHNAME, QUARTER) & Current Date/Time Retrieval (CURDATE, NOW).

-- Intermediate Level (Q25 – Q27): Date Arithmetic, Intervals & Formatting (DATEDIFF, DATE_ADD, DATE_SUB, DATE_FORMAT).

-- Advanced Level (Q28 – Q30): Business Days, Aging Analysis, SLA Compliance, and Complex Fiscal Calendar Calculations (CASE with Date Differences, Month-End Handling, Time Differences).

-- 🟢 Module 02: Built-in Functions | Date & Time Functions
-- 🇬🇧 English: Module 2 - Question 22 (Date & Time Functions - Beginner Level)
-- 📝 Scenario:
-- The executive sales reporting team is building a monthly and quarterly performance dashboard.
-- In the raw sales database, the order creation date is stored as a full ISO date string (e.g., '2023-08-15'). 
-- For reporting and aggregation, the team needs to extract individual time dimensions so they can slice sales by Year, Quarter, Month Number, Month Name, and Day of the Week.

-- 🎯 Your Task:
-- Write a clean SQL query to extract all original columns from the sales table, 
-- and generate the following 5 new calculated date parts from the order_date column:

-- order_year: The 4-digit year (e.g., 2023).

-- order_quarter: The calendar quarter number (1, 2, 3, or 4).

-- order_month_num: The numeric month (1 to 12).

-- order_month_name: The full text month name (e.g., 'August').

-- order_day_name: The full text day of the week (e.g., 'Tuesday').

-- ⚠️ Edge Case & Interview Instructions:
-- Use MySQL's native date extraction functions:

-- YEAR(date) for the year.

-- QUARTER(date) for the calendar quarter.

-- MONTH(date) for the numeric month.

-- MONTHNAME(date) for the month name.

-- DAYNAME(date) for the day of the week.

-- Alias these calculated fields strictly as requested above.

-- Append them alongside sales.*.
SET SQL_SAFE_UPDATES = 0;

UPDATE sales 
SET order_date = COALESCE(
    -- Try parsing as MM-DD-YYYY or M-D-YYYY first (e.g. 4-15-2017)
    STR_TO_DATE(REPLACE(order_date, '/', '-'), '%m-%d-%Y'),
    -- If that fails, try parsing as DD-MM-YYYY (e.g. 18-09-2002)
    STR_TO_DATE(REPLACE(order_date, '/', '-'), '%d-%m-%Y')
);

SET SQL_SAFE_UPDATES = 1;

SELECT 
    YEAR(order_date) AS order_year,
    QUARTER(order_date) AS order_quarter,
    MONTH(order_date) AS order_month_num,
    MONTHNAME(order_date) AS order_month_name,
    DAYNAME(order_date) AS order_day_name,
    sales.*
FROM sales;

-- Question 23 (Date & Time Functions - Beginner Level)
-- 📝 Scenario:
-- The database administration and compliance team is building a live auditing report.
--  Every time an analyst runs a data extraction query, 
--  the system needs to record the exact live system date and timestamp when the query was executed alongside each transaction record.

-- Additionally, the marketing team wants to calculate the current aging threshold by extracting the day difference between today's live execution date and the order_date.

-- 🎯 Your Task:
-- Write a clean SQL query to fetch all original columns from the sales table and create 3 new calculated fields:
-- current_execution_date: The live date at the moment of query execution (format: YYYY-MM-DD).
-- current_execution_timestamp: The full live date and time timestamp (format: YYYY-MM-DD HH:MM:SS).
-- days_since_order: The exact number of days elapsed between order_date and today's live execution date.
-- ⚠️ Edge Case Instructions:
-- Use CURDATE() (or CURRENT_DATE()) to retrieve today's live date.
-- Use NOW() (or CURRENT_TIMESTAMP()) to retrieve the live timestamp with time.
-- Use DATEDIFF(end_date, start_date) to compute days_since_order. Pass CURDATE() as the end_date and order_date as the start_date.
-- Alias these fields strictly as named above and append them alongside sales.*.
SELECT 
    CURDATE() AS current_execution_date,
    NOW() AS current_execution_timestamp,
    DATEDIFF(CURDATE(), order_date) AS days_since_order,
    sales.*
FROM sales;

-- Question 24 (Date & Time Functions - Beginner Level)
-- 📝 Scenario:
-- The corporate financial auditing team is conducting a quarter-end transaction verification. To ensure proper period cutoff and batching, auditors need to inspect the first and last days of the month in which each transaction occurred.
-- Additionally, the marketing team needs to extract the specific week number of the year for each order date to evaluate weekly promotional performance.
-- 🎯 Your Task:
-- Write a clean, optimized SQL query to pull all original columns from the sales table, and create 3 new calculated date fields:
-- month_start_date: The exact date corresponding to the 1st day of the month for each order_date (format: YYYY-MM-01).
-- month_end_date: The exact date corresponding to the last day of the month for each order_date.
-- order_week_num: The numerical calendar week number of the year (1 to 53).
-- ⚠️ Edge Case Instructions:
-- First Day Logic: Use the string/date formatting function DATE_FORMAT(order_date, '%Y-%m-01') to construct the 1st day of the month cleanly.
-- Last Day Logic: Use MySQL's native built-in function LAST_DAY(order_date) to dynamically calculate the end of the month (this automatically handles leap years like Feb 29 vs Feb 28!).
-- Week Number Logic: Use WEEK(order_date) (or WEEKOFYEAR(order_date)) to extract the week index.
-- Alias these fields strictly as month_start_date, month_end_date, and order_week_num, and append them alongside sales.*.

SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS month_start_date,
    LAST_DAY(order_date) AS month_end_date,
    WEEK(order_date) AS order_week_num,
    sales.*
FROM sales;

-- INTERMEDIATE LEVEL --
-- Question 25 (Date & Time Functions - Intermediate Level)
-- 📝 Scenario:
-- The customer experience and operations team at an e-commerce platform is establishing automated customer policy dates for every order in the sales table:
-- 30-Day Return Window: Customers are eligible to initiate product returns up to 30 days after the order_date.
-- 1-Year Warranty Expiration: Products come with a standard manufacturer warranty valid for 1 year after the ship_date.
-- Estimated Delivery Date: The logistics team estimates standard delivery to occur 7 days after the order_date.
-- 🎯 Your Task:
-- Write a clean, optimized SQL query to pull all original columns from the sales table and compute the following 3 new policy dates:
-- return_deadline: The exact date calculated by adding 30 days to order_date.
-- warranty_expiry_date: The exact date calculated by adding 1 year to ship_date.
-- estimated_delivery_date: The exact date calculated by adding 7 days to order_date.
-- ⚠️ Edge Case & Interview Instructions:
-- Use MySQL's native interval arithmetic function DATE_ADD(date, INTERVAL value unit):
-- For days: DATE_ADD(order_date, INTERVAL 30 DAY)
-- For years: DATE_ADD(ship_date, INTERVAL 1 YEAR)
-- Ensure you handle missing/NULL ship_date values gracefully (if an order hasn't shipped yet, warranty_expiry_date will naturally evaluate to NULL).
-- Alias the calculated fields strictly as return_deadline, warranty_expiry_date, and estimated_delivery_date, appending them alongside sales.*

SELECT 
    DATE_ADD(order_date, INTERVAL 30 DAY) AS return_deadline,
    DATE_ADD(ship_date, INTERVAL 1 YEAR) AS warranty_expiry_date,
    DATE_ADD(order_date, INTERVAL 7 DAY) AS estimated_delivery_date,
    sales.*
FROM sales;

-- (Intermediate Level) - Question 26 (Q26)
-- 🇬🇧 English: Module 2 - Question 26 (Date & Time Functions - Intermediate Level)
-- 📝 Scenario:
-- The inventory and fulfillment auditing team is conducting a historical order validation. To detect fraud and audit fulfillment compliance, they need to calculate three past timeline milestones for every transaction in the sales table:
-- Payment Verification Window: Payment verification is expected to take place 2 days before the order_date (e.g., pre-authorization lock).
-- System Inventory Hold Date: Inventory is reserved 5 days before the ship_date.
-- Customer Retention Outreach: The marketing team schedules a churn-prevention outreach campaign 14 days prior to today's live execution date.
-- 🎯 Your Task:
-- Write a clean, optimized SQL query to pull all original columns from the sales table and compute the following 3 new past-dated calculated fields:
-- payment_verification_date: The exact date calculated by subtracting 2 days from order_date.
-- inventory_hold_date: The exact date calculated by subtracting 5 days from ship_date.
-- retention_outreach_date: The exact date calculated by subtracting 14 days from today's live execution date (CURDATE()).
-- ⚠️ Edge Case & Interview Instructions:
-- Use MySQL's native interval subtraction function DATE_SUB(date, INTERVAL value unit):
-- DATE_SUB(order_date, INTERVAL 2 DAY)
-- DATE_SUB(ship_date, INTERVAL 5 DAY)
-- DATE_SUB(CURDATE(), INTERVAL 14 DAY)

-- Alternatively, understand that DATE_ADD(date, INTERVAL -value unit) produces the exact same result—interviewers often test if you know that
--  adding a negative interval is equivalent to DATE_SUB().
-- Alias the calculated fields strictly as payment_verification_date, inventory_hold_date, 
-- and retention_outreach_date, appending them alongside sales.*.

SELECT 
    DATE_SUB(order_date, INTERVAL 2 DAY) AS payment_verification_date,
    DATE_SUB(ship_date, INTERVAL 5 DAY) AS inventory_hold_date,
    DATE_SUB(CURDATE(), INTERVAL 14 DAY) AS retention_outreach_date,
    sales.*
FROM sales;

-- Question 27 (Date & Time Functions - Intermediate Level)
-- 📝 Scenario:
-- The business intelligence and reporting team is building a monthly executive summary dashboard.
-- Raw dates like '2023-08-15' are hard to read on executive slides.
-- The team wants you to transform order_date into three standardized business reporting string formats:
-- Format A (US Executive Style): Month Name, Day, 4-digit Year (e.g., 'August 15, 2023').
-- Format B (ISO Year-Month Code): 4-digit Year followed by a dash and 2-digit Month (e.g., '2023-08') — used extensively for GROUP BY monthly trends.
-- Format C (Short Business Date): Abbreviated Month, 2-digit Day, 2-digit Year with slashes (e.g., 'Aug/15/23').
-- 🎯 Your Task:
-- Write a clean SQL query to extract all original columns from the sales table, and generate 3 new formatted date strings from order_date:
-- formatted_date_long: Displays date as 'August 15, 2023'.
-- year_month_code: Displays date as '2023-08'.
-- formatted_date_short: Displays date as 'Aug/15/23'.
-- 📋 MySQL DATE_FORMAT() Format Specifiers:
-- %M = Full Month name (August) | %b = Abbreviated Month name (Aug) | %m = 2-digit Month (08)
-- %e or %d = Day of the month (15)
-- %Y = 4-digit Year (2023) | %y = 2-digit Year (23)

SELECT 
    DATE_FORMAT(order_date, '%M %e, %Y') AS formatted_date_long,
    DATE_FORMAT(order_date, '%Y-%m') AS year_month_code,
    DATE_FORMAT(order_date, '%b/%d/%y') AS formatted_date_short,
    sales.*
FROM sales;


-- ADVANCE LEVEL -- 
-- Question 28 (Date & Time Functions - Advanced Level)📝
-- Scenario:The logistics risk management team is building an automated audit pipeline to monitor order shipping SLA (Service Level Agreement) compliance
-- .The corporate logistics SLA states:Standard shipping time is within 3 days of order_date.Orders shipped within 0 to 3 days are classified 
-- as On-Time.Orders shipped after more than 3 days are classified as SLA Delayed.Orders that have not shipped yet (ship_date is NULL):
-- If the order was placed more than 5 days ago relative to today (CURDATE()), classify it as Critical Breach (Unshipped).
-- Otherwise, classify it as In Processing.🎯 Your Task:Write a clean, production-grade SQL query to pull all original columns from the sal
-- es table and compute two new calculated fields:actual_shipping_days: The exact integer difference between ship_date and order_date. 
-- If ship_date is NULL, this value should cleanly evaluate to NULL.sla_fulfillment_status:
--  A multi-condition classification status displaying 'On-Time', 'SLA Delayed', 'Critical Breach (Unshipped)', or 'In Processing'.
--  📋 Expected Logic Mapping:ship_date IS NULL AND DATEDIFF(CURDATE(), order_date) > 5 $\rightarrow$ 'Critical Breach (Unshipped)'ship_date IS NULL $\rightarrow$ 
--  'In Processing'DATEDIFF(ship_date, order_date) <= 3 $\rightarrow$ 'On-Time'ELSE $\rightarrow$ 'SLA Delayed'
--  ⚠️ Edge Case Instructions:Use DATEDIFF() inside a nested CASE WHEN statement
--  .Check IS NULL conditions first before evaluating numerical comparisons on ship_date to prevent unexpected evaluation ordering.
--  Alias the calculated fields strictly as actual_shipping_days and sla_fulfillment_status, appending them alongside sales.*.

SELECT DATEDIFF(ship_date, order_date) AS actual_shipping_days,
CASE 
        WHEN ship_date IS NULL AND DATEDIFF(CURDATE(), order_date) > 5 
            THEN 'Critical Breach (Unshipped)'
        WHEN ship_date IS NULL 
            THEN 'In Processing'
        WHEN DATEDIFF(ship_date, order_date) <= 3 
            THEN 'On-Time'
        ELSE 'SLA Delayed'
    END AS sla_fulfillment_status,
    sales.*
FROM sales;

-- Question 29 (Date & Time Functions - Advanced Level)📝 Scenario:The corporate accounts 
-- receivable and inventory risk team is analyzing transaction aging across all orders in the sales table.
--  They want to categorize every order based on how many days have elapsed between the order_date and 
--  - 30 Days: Orders placed within the last 30 days.31 - 60 Days: 
--  Orders placed between 31 and 60 days ago.61 - 90 Days: Orders placed between 61 and 90 days ago.90+ Days (Severe Aging)
--  : Orders placed more than 90 days ago.
--  🎯 Your Task:Write a clean, optimized, production-grade SQL query to pull all original columns from the sales table and create two new calculated fields:order_age_in_days: 
--  The exact numerical difference in days between today's live execution date (CURDATE()) and order_date.aging_tier:
--  A categorical label placing the record into '0 - 30 Days', '31 - 60 Days', '61 - 90 Days', or '90+ Days (Severe Aging)'
--  .📋 Expected Logic Mapping:$$\text{order\_age\_in\_days} = \text{DATEDIFF}(\text{CURDATE}(), \text{order\_date})$$$\text{order\_age\_in\_days} \le 30 \rightarrow \text{'0 - 30 Days'}$$\text{order\_age\_in\_days} \le 60 \rightarrow \text{'31 - 60 Days'}$$\text{order\_age\_in\_days} \le 90 \rightarrow \text{'61 - 90 Days'}$$\text{ELSE} \rightarrow \text{'90+ Days (Severe Aging)'}$⚠
--  ️ Edge Case Instructions:Combine DATEDIFF() and CURDATE() inside a CASE WHEN block.Structure the CASE WHEN conditions in sequential ascending order ($\le 30$, $\le 60$, $\le 90$). 
--  Because SQL evaluates CASE expressions top-to-bottom, writing $\le 60$ after $\le 30$ automatically catches values between 31 and 60 without needing an explicit BETWEEN clause!Alias
--  these calculated fields strictly as order_age_in_days and aging_tier, appending them cleanly using sales.*.
SELECT 
    DATEDIFF(CURDATE(), order_date) AS order_age_in_days,
    CASE 
        WHEN DATEDIFF(CURDATE(), order_date) <= 30 
            THEN '0 - 30 Days'
        WHEN DATEDIFF(CURDATE(), order_date) <= 60 
            THEN '31 - 60 Days'
        WHEN DATEDIFF(CURDATE(), order_date) <= 90 
            THEN '61 - 90 Days'
        ELSE '90+ Days (Severe Aging)'
    END AS aging_tier,
    sales.*
FROM sales;

-- Question 30 (Date & Time Functions - Advanced Level)
-- 📝 Scenario:The customer service and fulfillment operations team wants to identify orders placed over the weekend vs. orders placed on standard business working days in the sales table:Weekend Placement Flag: Any order placed on 
-- Saturday or Sunday requires additional processing time because fulfillment centers operate on reduced staffing.Business Day SLA Window: For orders placed on weekdays (Monday through Friday), standard processing begins immediately.
-- Day Index Tracking: To assist down-stream data pipelines, the engineering team wants the exact numerical day-of-week index where 1 = Sunday, 2 = Monday, ..., 7 = Saturday.🎯 Your Task:Write a clean, 
-- optimized SQL query to pull all original columns from the sales table and compute the following 2 new fields:day_of_week_num:
--  The numerical day of the week index for order_date using MySQL's native DAYOFWEEK(date) function (1 for Sunday through 7 for Saturday).
--  day_type: A categorical label evaluating to either Weekend or Business Working Day.📋 Expected Logic Mapping:DAYOFWEEK(order_date) IN (1, 7) $\rightarrow$ 'Weekend'ELSE $\rightarrow$ 'Business Working Day'
--  ⚠️ Edge Case & Interview Instructions:Note that DAYOFWEEK() in MySQL considers Sunday as Day 1 and Saturday as Day 7.
--  Be careful not to confuse DAYOFWEEK() with WEEKDAY(), where 0 = Monday and 6 = Sunday! Mentioning this distinction in interviews proves
--  deep SQL proficiency.Alias the calculated fields strictly as day_of_week_num and day_type, appending them alongside sales.*.

SELECT 
    DAYOFWEEK(order_date) AS day_of_week_num,
    CASE 
        WHEN DAYOFWEEK(order_date) IN (1, 7) 
            THEN 'Weekend'
        ELSE 'Business Working Day'
    END AS day_type,
    sales.*
FROM sales;
