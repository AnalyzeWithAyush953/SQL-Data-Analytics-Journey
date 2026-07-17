create database Superstore_sales;
use Superstore_sales;
select count(*)from sales
limit 5;
describe sales;

ALTER TABLE sales 
RENAME COLUMN `Order ID` TO order_id,
RENAME COLUMN `Order Date` TO order_date,
RENAME COLUMN `Customer Name` TO customer_name,
RENAME COLUMN `Customer ID` TO customer_id,
RENAME COLUMN `Segment` TO segment,
RENAME COLUMN `Region` TO region,
RENAME COLUMN `State` TO state,
RENAME COLUMN `Sub-Category` TO sub_category,
RENAME COLUMN `Product Name` TO product_name,
RENAME COLUMN `Product ID` TO product_id,
RENAME COLUMN `Sales` TO sales,
RENAME COLUMN `Profit` TO profit,
RENAME COLUMN `Discount` TO discount,
RENAME COLUMN `Quantity` TO quantity,
RENAME COLUMN `Postal Code` TO postal_code,
RENAME COLUMN `Ship Mode` TO ship_mode;

Alter table sales
rename column `ship date` to ship_date;

/* =========================================================================
   LEVEL 1: BEGINNER QUERIES (Q1 - Q5)
   ========================================================================= */
-- These questions ensure your basic structural syntax and keywords are flawless.
-- Q1 (Focus: SELECT & Columns): The marketing team wants a clean list of operations.
Extract the Order ID, Order Date, Customer Name, and Sales columns from the Superstore table. Limit your output to only the first 10 rows.
-- select `order id` ,`order date`,`customer name`,`customer id`
-- from sales
-- limit 10; sloution 1 before remane column , we use ` ` 
select order_id,order_date,customer_id,customer_name 
from sales;
-- Q2 (Focus: WHERE with Basic Operator): Find all rows where the operational Profit is strictly negative (less than 0),
so the finance team can audit losses. Return all columns.
select * from sales
where profit < 0;
-- Q3 (Focus: LIKE basic pattern matching): Find all records where the Customer Name starts exactly with the capital letter 'Z'.
select * from sales
where customer_name like 'Z%';
-- Q4 (Focus: IN fixed values): A new shipping strategy is being tested. Retrieve all records where the Ship Mode is either 'Second Class' or 'Standard Class'.
select * from sales
where ship_mode in ('Second Class','Standard class'); -- solution  1 
select * from sales
where ship_mode = 'second class' or ship_mode = 'standard class';
-- Q5 (Focus: BETWEEN ranges): Retrieve all orders where the transaction Sales value falls strictly between $100 and $200 (inclusive).
select * from sales
where sales between 100 and 200;
 select * from sales 
 where sales>=100 and sales<=200;

/* =========================================================================
   LEVEL 2: INTERMEDIATE QUERIES (Q6 - Q10)
   ========================================================================= */
-- These questions introduce logical combinations and common exclusions used in business reporting.
-- Q6 (Focus: WHERE with Compound Operators): Extract unique (DISTINCT) Customer IDs belonging to the 'Corporate' segment who live specifically in the 'California' state.
select distinct customer_id from sales
where segment = 'corporate' and state = 'California'; 
-- Q7 (Focus: NOT IN exclusion): The inventory manager wants to ignore heavy logistics items. Select all records where the Sub-Category is NOT 'Tables', 'Chairs', or 'Bookcases'.
select * from sales
where sub_category not in ('Tables','chairs','bookcases');
-- Q8 (Focus: LIKE inside string matching): Find all records where the Product Name contains the word 'Phone' anywhere within it (case-insensitive in MySQL).
select * from sales
where product_name like '%phone%';
-- Q9 (Focus: Logical Precedence AND / OR): Extract orders from the 'Technology' category that either have a Sales value greater than $1000 OR a Discount equal to 0. (Hint: Watch your bracket placement!)
select * from sales
where  (category = 'technology') and (sales>1000 or discount = 0);
-- Q10 (Focus: NOT BETWEEN inversion): Extract all orders where the Quantity purchased is completely outside the standard range of 2 to 5 units (i.e., less than 2 or greater than 5)
select * from sales
where quantity < 2 or  quantity > 5 ;

SELECT * FROM sales
WHERE quantity NOT BETWEEN 2 AND 5;

/* =========================================================================
   LEVEL 3: ADVANCED QUERIES (Q11 - Q15)
   ========================================================================= */
-- These questions simulate complex business requests and address your specific MySQL Workbench data import behavior.

-- Q11 (Focus: IS NULL vs Empty String ''): Find all records where the Postal Code data is missing. Because you imported using a wizard, write the filter to catch both true database NULL values and hidden empty blank strings ('').
SELECT * FROM sales
WHERE postal_code IS NULL 
   OR postal_code = '' 
   OR TRIM(postal_code) = '';

-- Q12 (Focus: Wildcard Escape Character): The quality team noticed some bad product codes. Find all rows where the Product ID contains an actual hyphen/dash (-) followed immediately by a literal percent sign (%) anywhere in the string. Use an explicit ESCAPE clause.
select * from sales 
where product_id like '%-\%%';
-- Q13 (Focus: Complex Boolean Combinations): Find all orders in the 'Consumer' segment where the Region is either 'West' or 'East', AND the customer suffered a loss (Profit < 0), but the Discount given was less than 0.2.
select * from sales
where ( region in ('west','east')) and (segment ='consumer' ) and (profit<0) and (discount<0.2);
-- Q14 (Focus: Dynamic Text Matching with LIKE): Select all orders where the Customer Name has the letter 'a' as its second character, and the letter 'e' as its fourth character (e.g., 'James', 'Dany'). (Hint: Use the single-character wildcard _ appropriately).
select * from sales
where customer_name like '_a_e%';
-- Q15 (Focus: Data Integrity Filtering): Retrieve all records where Sales is greater than $500, but the Customer Name contains trailing spaces or numerical system errors (represented for this practice as any name containing the number '1' or '2')
