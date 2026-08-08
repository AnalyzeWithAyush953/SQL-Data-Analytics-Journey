# SQL Data Analyst Journey

Welcome to my SQL data analytics portfolio. This repository contains my clean code scripts and practice queries using retail transaction data to build a solid foundation for a Data Analyst career.

## Tech Stack
* Database Engine: MySQL
* IDE Client: MySQL Workbench
* Domain Focus: E-Commerce Retail Transaction Datasets

---

## Learning Syllabus & Modules Index

* 📁 [Module 01: Data Filtering](./Module-01-Data-Filtering/)
  * Basic data retrieval and row filtering using WHERE, AND/OR logic, range filters (BETWEEN), list scanning (IN), and text pattern matching (LIKE wildcards).
* 📁 [Module 02: Built-in Functions](./Module-02-Built-in-Functions/)
  * Data cleaning and transformation using string functions (CONCAT, UPPER/LOWER), handling missing values (NULL handling with COALESCE), and basic date and number calculations.
* 📁 [Module 03: Aggregations & Grouping](./Module-03-Aggregations-and-Grouping/)
  * Aggregating transactional records into high-level business summaries using COUNT, SUM, AVG, MIN, MAX, single & multi
    column GROUP BY, HAVING vs WHERE filtering, COALESCE aggregations, SUM(CASE WHEN...) conditional pivoting, dynamic CASE
    WHEN bucketing, and monthly time-series metrics.
* 📁 [Module 04: Conditional Logic](./Module-04-Conditional-Logic/)
  * Applying conditional rules, missing value substitutions, and dynamic pivoting using CASE WHEN, COALESCE, and NULLIF.
* 📁 [Module 05: Joins & Set Operations](./Module-05-Joins-and-Set-Operations/)
  * Multi-table relationship queries using INNER, LEFT, RIGHT, FULL OUTER JOIN emulation, SELF JOIN, Non-EQUI JOIN, CROSS JOIN, and UNION/UNION ALL.
  * (Includes custom database setup: created a `customers` dimension table, added guest orders in `sales` for orphan key testing, and created non-buying customer profiles).
* 📁 [Module 06: Subqueries & CTEs](./Module-06-Subqueries-and-CTEs/)
  * Modular query design covering Scalar Subqueries, Multi-Row IN filters, Correlated EXISTS subqueries, Derived Tables, Chained CTEs (`WITH` clause), subquery refactoring, and Recursive CTEs (`WITH RECURSIVE`).
* 📁 [Module 07: Window Functions](./Module-07-Window-Functions/)
  * Advanced analytical query design covering `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, `LEAD()`, cumulative            running totals, moving/rolling averages (`ROWS BETWEEN`), data deduplication, and customer segmentation using `NTILE()`      & `PERCENT_RANK()`.
* 📁 [Module 08: Advanced Aggregations](./Module-08-Advanced-Aggregations/Topic-08-Advanced-Aggregations.sql)
  * Multi-level dimensional rollups using `WITH ROLLUP`, `GROUPING()` binary flags for subtotal labeling, and simulated multi-axis `CUBE` aggregations.
    
