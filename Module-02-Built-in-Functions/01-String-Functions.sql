-- Topic 2:  Module 2 
-- Beginner Level  string function - Question 1 (Q1)  
-- (Q1) * Scenario: The marketing team wants to prepare a standard shipping label format to paste on courier packets
-- Task (Focus: CONCAT() & UPPER() String Functions): Create a new column from the sales table
--  where the customer's name is entirely in capital letters (UPPERCASE),
-- and immediately followed by their State inside brackets.
-- Important Instruction: Do not forget to give this newly created column an alias using AS customer_lable
select * , concat(upper(customer_name),((state))) as customer_lable
from sales; -- written my me 

SELECT sales.*, CONCAT(UPPER(customer_name), ' (', state, ')') AS customer_label
FROM sales;-- written by computer

-- English:
-- The COALESCE(column, replacement) function checks the column. If the value is present, it uses it. If the value is NULL,
-- it automatically replaces it with a backup text provided by you. This ensures that CONCAT() never receives a NULL value.
-- English: Replacing NULL with a placeholder string
SELECT sales.*, CONCAT(UPPER(customer_name), ' (', COALESCE(state, 'No State Provided'), ')') AS customer_label
FROM sales;

-- 🟢 Sub-Topic 2A: String Functions | Beginner Level - Question 2 (Q2)  
-- Scenario: The operations team noticed that many product IDs (product_id) are too long to read 
-- on standard scanning handheld devices. They only want to see the specific category code hidden inside the product ID.
-- Task (Focus: LEFT() or SUBSTRING() String Functions): Write a query to retrieve all rows from the sales table, 
-- and extract exactly the first 3 characters from the product_id column.
-- Important Instruction: Rename this newly calculated column as short_category_code using an alias.
SELECT sales.*, LEFT(product_id, 3) AS short_category_code
FROM sales; -- also  learn substring , left and right 

-- Ouestion 3 Scenario: The quality control team noticed that due to an old database script, several order IDs (order_id) were stored with inconsistent lowercase formatting (e.g., ca-2023-152156). 
-- They want to standardize all order IDs into clean, professional uppercase text.
-- Task (Focus: UPPER() String Function): Write a query to fetch all records from the sales table, and
-- transform the entire text of the order_id column into capital letters
-- Rename this newly formatted column as standardized_order_id using an alias.
select * , upper(order_id) as standardized_order_id 
from sales;

-- questio 4  The customer service department noticed that when printing delivery packages,
-- the customer names look unprofessional because they are stored in inconsistent cases (e.g., JEFF WALON, todd sumrall, or Claire Gute).
--  To standardise the shipping labels, the company wants to display all customer names strictly in lowercase letters.

-- 🎯 Your Task:
-- Write a clean SQL query to select all columns from the sales table, 
-- and transform the entire text values of the customer_name column into lowercase letters.

-- ⚠️ Edge Case Instructions:
-- Use the LOWER() string function to convert the text characters.
-- Rename this newly formatted column as cleaned_customer_name using an explicit alias.
-- Ensure all other transaction columns are pulled alongside this new column.

select lower(customer_name) as cleaned_customer_name ,sales. *
from sales;

-- Question 5
-- 📝 Scenario:
-- The fulfillment logistics team wants to generate automated packaging slips. 
-- For clear visual sorting on boxes, they need a standardized text string called a Product Label. This label must combine the category and sub_category columns together, formatted inside square brackets and separated by a hyphen with spaces.

-- 🎯 Your Task:
-- Write a clean SQL query to retrieve all columns from the sales table, and create a new calculated column named product_label.

-- 📋 Required Output Format:
-- If the category is Technology and the sub-category is Phones, the new column must display the text exactly as: [Technology - Phones]
--  ⚠️ Edge Case Instructions:
-- Use the CONCAT() string function to assemble the text pieces, hardcoding the brackets [ ] and the separator -.
-- Alias the resulting column strictly as product_label.

select concat('[',Category, '-' ,sub_category, ']') as product_lable ,sales.*
from sales;-- if there is no null values 

select CONCAT('[', category, ' - ', COALESCE(sub_category, 'Unknown'), ']') as product_lable, sales.*
from sales;-- if there is null values 

---- INTERMEDIATE LEVEL----
-- Question 6 (Intermediate Level)
-- 📝 Scenario:
-- The data engineering pipeline frequently syncs category text fields from various third-party web forms. 
-- Due to poor frontend validation, users often accidentally press the spacebar before or after typing. 
-- As a result, many product entries have messy exterior blank spaces (e.g., '  Technology ' or ' Office Supplies  ').
-- These invisible spacing flaws are corrupting our database filters. For instance, 
-- a regular WHERE category = 'Technology' query fails to catch records stored as '  Technology '. The analytics team demands a clean, standardized product master list.
-- 🎯 Your Task:
-- Write a clean SQL query to retrieve all data records from the sales table, 
-- and generate a new calculated column that fulfills two conditions simultaneously inside a single step:
-- It must strip out all unwanted leading (front) and trailing (back) white spaces from the category column.
-- It must immediately transform that cleaned text completely into UPPERCASE letters.
-- ⚠️ Edge Case Instructions:
-- Use nested functions to combine TRIM() and UPPER() on the exact same column line.
-- Ensure that internal spaces within words (like the single space in Office Supplies) are completely preserved and not removed.
-- Rename this newly transformed data column as cleaned_category using an explicit alias.
-- Append this column alongside all original columns using your verified sales.* qualification technique to avoid syntax bugs.

Select upper(trim(category)) as cleaned_category , sales.*
from sales;

--  Question 7 (Intermediate Level)
-- 📝 Scenario:
-- The database security and masking team wants to generate custom shortened identifiers for internal reporting. 
-- They need a new code called sub_category_code.
-- This code must consist of only the first 3 characters of whatever value is stored in the sub_category column, and it must be displayed completely in uppercase.

-- 🎯 Your Task:
-- Write a clean SQL query to retrieve all data rows from the sales table, and generate a new calculated column named sub_category_code.
-- 📋 Expected Output Format:
-- If the sub-category is Accessories, the code must display exactly as: ACC
-- If the sub-category is Chairs, the code must display exactly as: CHA
-- If the sub-category is Phones, the code must display exactly as: PHO
-- ⚠️ Edge Case Instructions:
-- Use the string extraction function SUBSTRING() (or its short form SUBSTR()) to chop out the first 3 characters. (Hint: The starting index in SQL is 1, not 0 like in Python/Java!)
-- Wrap it inside UPPER() to ensure it stays in capital letters.
-- Alias this column explicitly as sub_category_code and append it alongside sales.*.

select upper(left(sub_category,3)) as sub_category_code , sales.*
from sales;

select upper(substring(sub_category,1,3)) as sub_category_code , sales.*
from sales; -- using subcategory 

-- Question 8 (Intermediate Level)
-- 📝 Scenario:
-- The E-Commerce inventory control department is migrating to a new barcode scanner system. 
-- The old system stored all product IDs (product_id) using a forward slash separator (e.g., OFF/AP/10002892). 
-- However, the new enterprise scanner software cannot read slashes and strictly requires all identifiers to use a clean hyphen character (-) instead.
-- Changing the data permanently in the server requires a heavy database write permit, 
-- so the analytics team needs an instant report where the slashes are dynamically replaced for the reporting view.
-- 🎯 Your Task:
-- Write a clean SQL query to fetch all data records from the sales table, 
-- and create a new calculated column named migrated_product_id.

-- 📋 Expected Output Format:
-- If the original product ID is stored as OFF/AP/10002892, your new column must output it exactly as: OFF-AP-10002892
-- If the original product ID is TEC/PH/10002033, it must transform to: TEC-PH-10002033
-- ⚠️ Edge Case Instructions:
-- Use the string swapping function REPLACE() to find every occurrence of '/' and switch it to '-'.
-- Alias this newly generated column explicitly as migrated_product_id.
-- Keep your code production-ready by using sales.* to pull all other columns alongside the new value.
select replace(product_id,'/','-') as migrated_product_id ,sales.*
from sales;

-- Question 9 (Intermediate Level)
-- 📝 Scenario:
-- The database warehouse administrator wants to run a data compliance audit on the sales table.
--  According to strict corporate data engineering layout rules, 
-- every valid Product ID (product_id) in the company database must consist of exactly 15 characters (e.g., OFF-AP-10002892 has 15 characters). Any product ID that is shorter or longer than 15 characters represents a data corruption anomaly or human entry error that needs to be caught and investigated immediately.

-- 🎯 Your Task:
-- Write a clean SQL query to extract all original columns from the sales table, 
-- but filter the output to show only those specific rows 
-- where the Product ID violates the data standard (i.e., its character length is NOT equal to 15).
-- ⚠️ Edge Case Instructions:
-- Use the built-in string length function LENGTH() (or CHAR_LENGTH()) to count the characters.
-- Place this function condition directly inside the WHERE clause to perform row-level filtering based on text length.
-- Do not create any new calculated columns in the SELECT statement; 
-- just pull all original details using your qualified sales.* technique for the rows that fail the audit.
select * from sales
where length(product_id) != 15;

-- Question 10 (Q10)
-- Let's move directly to Intermediate Level - Question 10 (Q10), which will be the absolute final challenge of our intermediate track for this module!
-- 🇬🇧 English: Module 2 - Question 10 (Intermediate Level)
-- 📝 Scenario:
-- The business operations team wants to cross-verify data consistency between the product_id column and the actual item classification details.
--  Every standardized product ID is recorded in a fixed hyphenated pattern: [Category Code]-[SubCategory Code]-[Sequence Number] (e.g., in OFF-AP-10002892, 
-- the middle section AP represents the sub-category short code).
-- To build an automated validation report, they need to pull out just that middle sub-category code dynamically for every single record.
-- 🎯 Your Task:
-- Write a clean SQL query to fetch all original columns from the sales table, 
-- and create a new calculated column named extracted_sub_code 
-- that contains only the middle 2 characters of the product_id string (the text between the first and second hyphens).
-- 📋 Expected Output Format:
-- If the product ID is OFF-AP-10002892, the new column must extract exactly: AP
-- If the product ID is TEC-PH-10002033, the new column must extract exactly: PH
-- If the product ID is FUR-CH-10004030, the new column must extract exactly: CH
select substring(product_id,5,2) as extracted_sub_code ,sales.*
from sales ;

-- ADVANCED LEVEL--
-- Question 11 (Advanced Level)
-- 📝 Scenario:
-- The CRM marketing team wants to run a personalized email campaign. To make the emails feel professional, 
-- they want to address clients by their First Name and Last Name in separate columns. Currently, 
-- the database stores the complete name inside a single column called customer_name (e.g., 'Jeff Walon', 'Claire Gute', or 'Todd Sumrall').
-- Because every customer's name has a different length, 
-- you cannot use a fixed number index like we did in the intermediate question. 
-- You must find the blank space character dynamically for every row to split the text.
-- 🎯 Your Task:
-- Write a clean, dynamic SQL query to extract all original columns from the sales table, and generate two new calculated columns:
-- first_name: Extracts everything before the blank space.
-- last_name: Extracts everything after the blank space.
-- ⚠️ Edge Case & Interview Instructions:
-- Use the LOCATE(' ', customer_name) (or POSITION) function to find the exact dynamic position of the space character for each row.
-- Use LEFT() or SUBSTRING() combined with that dynamic space position to chop out the first_name.
-- Use SUBSTRING() starting from space position + 1 to extract the last_name cleanly to the end of the text.
-- Alias the new columns strictly as first_name and last_name, appending them alongside sales.*.

SELECT 
    LEFT(customer_name, LOCATE(' ', customer_name) - 1) AS first_name,
    SUBSTRING(customer_name, LOCATE(' ', customer_name) + 1) AS last_name,
    sales.*
FROM sales;

-- Question 12 (Advanced Level)
-- 📝 Scenario:
-- To comply with strict global data privacy regulations (GDPR), 
-- the cybersecurity compliance team has mandated that customer identities must be masked in all analytical dashboards. 
-- The security policy states that for every customer record, the First Name must remain fully visible, 
-- followed by the space, but the Last Name must be entirely replaced with asterisks (*) matching the exact character length of that last name.

-- Because each customer's last name has a different length (e.g., Walon needs 5 asterisks, while Gute needs 4 asterisks),
--  you cannot use a hardcoded string like '****'. The masking must be completely dynamic row-by-row.
-- 🎯 Your Task:
-- Write a highly optimized SQL query to pull all original columns from the sales table, 
-- and generate a new calculated column named masked_customer_name which hides the last name dynamically.
-- 📋 Expected Output Format:
-- If customer_name is 'Jeff Walon', the output must be: 'Jeff *****'
-- If customer_name is 'Claire Gute', the output must be: 'Claire ****'
-- If customer_name is 'Todd Sumrall', the output must be: 'Todd *******'
-- ⚠️ Edge Case & Interview Instructions:
-- Use LOCATE() to find the position of the blank space.
-- Use LEFT() to extract the first name along with its following space.
-- Calculate the length of the last name dynamically using a subtraction math operation inside LENGTH().
-- Use the built-in string multiplication function REPEAT(string, count) to generate the exact number of asterisks needed.
-- Merge the visible first name and the dynamic asterisks together using CONCAT().
-- Alias the final output strictly as masked_customer_name and append it alongside sales.*.

SELECT CONCAT(LEFT(customer_name, LOCATE(' ', customer_name)), 
REPEAT('*', LENGTH(customer_name) - LOCATE(' ', customer_name))) AS masked_customer_name,
sales.*
FROM sales;
