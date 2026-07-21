--  NUMERIC BEGINEER LEVEL QUESTIONS--
-- Question 13 (Numeric Functions - Beginner Level)
-- 📝 Scenario:
-- The corporate finance auditing team is designing the annual sales performance master dashboard. 
-- While scanning the transaction records in the company database,
-- they noticed that the sales (monetary amount) numeric column contains messy entries stored with up to four decimal positions (e.g., 261.9600, 731.9400, or 14.6200). 
-- According to corporate auditing guidelines and executive reporting standards, all monetary financial values must strictly be displayed with exactly 2 decimal places.

-- 🎯 Your Task:
-- Write a clean SQL query to extract all original columns from the sales table, 
-- and generate a new calculated column named formatted_sales. 
-- The numerical values in this new column must be rounded off to exactly 2 decimal places.

-- ⚠️ Edge Case Instructions:
-- Use the built-in mathematical function ROUND(column_name, decimals) to perform the rounding calculation.
-- Alias this newly formatted monetary column strictly as formatted_sales.
-- Keep your script safe from compilation bugs by using the sales.* qualification technique to display the rest of the original fields.

SELECT round(sales,2) as formatted_sales,sales.*
from sales;

-- Question 14 (Numeric Functions - Beginner Level)
-- 📝 Scenario:
-- The E-commerce warehouse log department manages large boxes for shipping items.
--  When processing shipping quotes, the warehouse software reads the volume weight calculations 
--  which generates fractional box values (e.g., a batch of goods needs 4.1 or 7.9 shipping pallets).
-- Logistically, you cannot order a partial or fraction of a shipping box. 
-- The company policy dictates that the system must always round up to the next nearest whole integer (whole number) to ensure there is always enough room to pack the goods securely, even if the decimal fraction is very small.
-- 🎯 Your Task:
-- Write a clean SQL query to fetch all original columns from the sales table,
-- and create a new calculated column named allocated_boxes. 
-- This column must round up the numeric values from the profit column to the next highest absolute whole integer.
-- ⚠️ Edge Case Instructions:
-- Use the built-in mathematical function CEIL() (or its full name CEILING()) to perform this upper-bound integer transformation. 
-- (For instance, 4.1 must become 5, and 7.9 must become 8).
-- Rename this calculated field strictly as allocated_boxes.
-- Keep the script clean by appending it alongside sales.*.

select ceiling(profit) as allocated_boxes ,sales.*
from sales;

-- Question 15 (Q15), which will complete our beginner track for this numeric domain!
--  English: Module 2 - Question 15 (Numeric Functions - Beginner Level)
-- 📝 Scenario:
-- The corporate financial planning team is auditing retail discount structures. 
-- When processing absolute values, they notice that the variance calculations in the profit column sometimes yield negative numbers 
-- due to operational losses (e.g., -25.46 or -110.12).
-- For a new high-level performance metrics report, the team needs to see only the magnitude of the financial variance (the distance from zero), completely eliminating the negative signs so all numbers display positively.
-- 🎯 Your Task:
-- Write a clean SQL query to fetch all original columns from the sales table, 
-- and create a new calculated column named absolute_profit_margin.
--  This column must convert all profit values into their absolute positive representation.
-- ⚠️ Edge Case Instructions:
-- Use the built-in mathematical function ABS(column_name) to remove the negative signs. (For instance, -45.50 must dynamically become 45.50, while positive 12.30 remains 12.30).
-- Rename this new calculated column strictly as absolute_profit_margin.
-- Keep the layout professional by using sales.* to append it alongside the rest of the original row records.

select abs(profit) as  absolute_profit_margin, sales.*
from sales;

-- INTERMEDIATE LEVEL-- 
-- Question 16 (Numeric Functions - Intermediate Level)📝 Scenario
-- :The sales performance management team is performing a deep calculation of commission payouts for corporate account managers. 
-- According to the company's new compensation matrix, 
-- the commission score for a transaction is determined by taking the absolute total profit value generated, 
-- raising it to the power of 2 (squaring it), and then dividing that final squared result by $100$.
-- Because some retail transactions resulted in operational losses (negative profit), 
-- we must absolutely make sure that the base profit is converted into its absolute positive representation before it is raised to the power,
--  avoiding any negative exponent or sign errors during high-value financial aggregations.
--  🎯 Your Task:Write a clean, optimized SQL query to pull all original columns from the sales table, 
-- and create a new calculated column named commission_score that calculates:$$\text{commission\_score} = \frac{(\vert{}\text{profit}\vert{})^2}{100}$$
--  ⚠️ Edge Case Instructions
--  :Nest the functions perfectly: First, use ABS() to clean the profit column, 
--  then use the exponent function POWER(base, exponent) (or POW()) to square that positive value.
--  Divide the entire squared output by 100.Alias this final calculated field explicitly as
--  commission_score and append it cleanly using sales.*.

SELECT POWER(ABS(profit), 2) / 100 AS commission_score,sales.*
FROM sales;

-- Question 17 (Numeric Functions - Intermediate Level)
-- 📝 Scenario:
-- The corporate internal quality assurance (QA) and auditing team wants to conduct a random spot-check audit on the sales table. 
-- Instead of reviewing transactions sequentially, they want to inject an unbiased, random element to select target rows.
-- The compliance system requires that every row in the output must be assigned a dynamic decimal score between 0 (inclusive) and 100 (exclusive).
-- To prevent data analysts from seeing a clean block of repetitive numbers, this numeric scale must be completely unpredictable row-by-row.
-- 🎯 Your Task:
-- Write a clean SQL query to fetch all original fields from the sales table, 
-- and generate a new calculated column named audit_random_weight. 
-- The values in this new column must contain a dynamically generated random decimal number scaled up to a range between 0 and 100.
-- ⚠️ Edge Case Instructions:
-- Use the standard built-in mathematical generator RAND() which natively outputs a decimal between 0 and 1.
-- Crucial Math Scaling: Multiply the output of the function by 100 inside,
-- your column expression to shift the decimal range up appropriately (e.g., 0.4567 becomes 45.67).
-- Alias this newly generated row-level identifier strictly as audit_random_weight and append it alongside sales.*.
SELECT RAND() * 100 AS audit_random_weight,sales.*
FROM sales;

-- Question 18 (Numeric Functions - Intermediate Level)
-- 📝 Scenario:
-- The marketing team is running an experimental conversion campaign and 
-- wants to distribute promotional tokens to customers based on their transaction size. 
-- The rules state that the number of tokens a customer receives is calculated by dividing their sales amount by the item quantity, 
-- and then finding the remainder left over after dividing that per-item value by 5.
-- To make this computation completely bulletproof for financial dashboards, 
-- the team wants to drop the trailing decimal cents completely from the per-item calculation before extracting the remainder.
-- 🎯 Your Task:
-- Write a clean, optimized SQL query to pull all original columns from the sales table, and 
-- generate a new calculated column named token_remainder that processes:
-- Divide sales by quantity.
-- Drop all decimal fractions from that result to get a clean whole number using the FLOOR() function.
-- Calculate the mathematical remainder of that floor value when divided by 5.
SELECT MOD(FLOOR(sales / quantity), 5) AS token_remainder,sales.*
FROM sales;

-- Question 19 (Numeric Functions - Intermediate Level)📝 Scenario:The executive sales planning board is analyzing the efficiency of our pricing markdown structures.
--  They have noticed that the discount column contains fractional percentages stored with varying decimal precision.
--  To calculate clear discount variations without getting overwhelmed by minor trailing fractions, the analytics manager wants you to extract only the fractional decimal component of the discount value for each transaction (i.e., just the part after the decimal point).For example,
--  if an item has a discount of 0.23, the extracted value must be exactly 0.23. If an item has a discount of 0.15, 
--  the extracted value must be 0.15. If it's a whole number like 0.00 or 1.00, the output must evaluate to 0.00.🎯 
--  
--  Your Task:Write a clean, optimized SQL query to pull all original columns from the sales table,
--  and generate a new calculated column named discount_decimal_part. This column must capture only the fractional part of the
--  numbers stored in the discount column.⚠️ 
-- Edge Case Instructions:Math Logic Shortcut: You can isolate the fractional part of 
--  any positive number by subtracting its base whole integer from the original value:
-- $$\text{Fractional Part} = \text{discount} - \text{FLOOR}(\text{discount})$$Wrap 
-- the final subtraction result inside a ROUND(..., 2) function to clean up potential floating-point representation anomalies in the database engine
--  .Alias this final column strictly as discount_decimal_part and append it cleanly using sales.*.
SELECT ROUND(discount - FLOOR(discount), 2) AS discount_decimal_part,sales.*
FROM sales;

-- Question 20 (Numeric Functions - Intermediate Level)📝 
-- Scenario:The risk management and quantitative analytics team is building a volatility risk model for retail transaction profits.
-- In risk modeling, high variance in profit (whether huge positive gains or huge negative losses) indicates higher transaction volatility.
-- To normalize this variance for executive risk reporting, the team needs to compute a normalized Volatility Score.
-- The corporate rule states that for every row, the Volatility Score is calculated by first taking the absolute value of the profit, 
-- calculating its Square Root ($\sqrt{x}$), and then rounding the final result to 1 decimal place.🎯 
-- Your Task:Write a clean, optimized SQL query to pull all original columns from the sales table,
-- and generate a new calculated column named profit_volatility_score.📋 
-- Expected Formula:$$\text{profit\_volatility\_score} = \text{ROUND}(\sqrt{\vert{}\text{profit}\vert{}}, 1)$$
-- ⚠️ Edge Case Instructions:Nest the functions carefully: 
-- Use ABS() to handle any negative profit records first, 
-- preventing standard square root compiler domain errors (since square roots of negative numbers fail in SQL).
-- Use the mathematical square root function SQRT() on the positive profit.
-- Wrap the calculated output inside ROUND(..., 1) to restrict the decimal placement to exactly 1 position.
-- Alias this new column strictly as profit_volatility_score and append it cleanly using sales.*.

SELECT 
    ROUND(SQRT(ABS(profit)), 1) AS profit_volatility_score,sales.*
FROM sales;

-- advanced level question -- 
 -- Module 2 - Question 21 (Numeric Functions - Advanced Level)📝 Scenario:
--  The corporate financial risk team wants to calculate a Profit Margin Logarithmic Weight for each transaction in the sales table.
--  In quantitative finance, raw ratios can skew analytics due to extreme outliers, 
--  so analysts transform ratios using a Natural Logarithm ($\ln$).T
--  he risk policy defines the calculation as follows:First, 
--  calculate the unit revenue as:$$\text{unit\_revenue} = \frac{\text{sales}}{\text{quantity}}$$Next, 
--  adjust the profit ratio relative to the unit revenue:$$\text{raw\_ratio} = 1 + \left\vert{} \frac{\text{profit}}{\text{unit\_revenue}} \right\vert{}$$Compute the Natural 
--  Logarithm ($\ln$) of this raw_ratio using the built-in LOG() function.Finally, round the result to 4 decimal places.
--  🎯 Your Task:Write a clean, production-grade SQL query to extract all original columns from the sales table and generate a new calculated column named log_margin_weight.
--  📋 Expected Formula:$$\text{log\_margin\_weight} = \text{ROUND}\left( \text{LOG}\left( 1 + \left\vert{} \frac{\text{profit}}{\frac{\text{sales}}{\text{quantity}}} \right\vert{} \right), 4 \right)$$⚠️ 
--  Edge Case Instructions:Nest the expressions carefully from the inside out:Unit revenue: sales / quantityProfit ratio: profit / (sales / quantity)Absolute value: ABS(...)Shift by 1: 1 + ABS(...)Natural Logarithm: LOG(...)
--  Decimal rounding: ROUND(..., 4)Alias this field strictly as log_margin_weight.
--  Use the qualified sales.* syntax to retrieve all original columns alongside the calculated field.

SELECT ROUND(LOG(1 + ABS(profit / (sales / quantity))), 4) AS log_margin_weight, sales.*
FROM sales;
