-- Data Cleaning

-- Preview the raw data to understand its structure and identify any obvious issues
SELECT * FROM train;

-- 1. Remove Duplicates
-- Using a CTE to rank rows based on the columns that should uniquely identify a record
-- Duplicates are defined by the combination of these columns, and only the first occurrence is kept
WITH cte AS 
(
	SELECT *,
		RANK() OVER(PARTITION BY order_id, order_date, ship_date, ship_mode, 
		customer_id, customer_name, segment, country, state, postal_code, region, 
		product_id, category, sub_category, product_name, sales ORDER BY row_id) AS row_num
	FROM train
)
SELECT *
FROM cte
WHERE row_num > 1; -- Returns rows that have duplicates

-- 2. Standardize Data/Values

-- Check if the order_date follows the correct format (YYYY-MM-DD)
SELECT order_date
FROM train
WHERE order_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Check if the ship_date follows the correct format (YYYY-MM-DD)
SELECT ship_date
FROM train
WHERE ship_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Update order_date to ensure it matches the correct format (DD/MM/YYYY -> YYYY-MM-DD)
SELECT order_date, STR_TO_DATE(order_date, '%d/%m/%Y') AS formatted_date
FROM train;

UPDATE train
SET order_date = STR_TO_DATE(order_date, '%d/%m/%Y');

-- Update ship_date to ensure it matches the correct format (DD/MM/YYYY -> YYYY-MM-DD)
SELECT ship_date, STR_TO_DATE(ship_date, '%d/%m/%Y') AS formatted_date
FROM train;

UPDATE train
SET ship_date = STR_TO_DATE(ship_date, '%d/%m/%Y');

-- Alter the column data type for order_date and ship_date to DATE for consistency
ALTER TABLE train
MODIFY COLUMN order_date DATE;

ALTER TABLE train
MODIFY COLUMN ship_date DATE;

-- Check if there are any cases where the order_date is after the ship_date
-- This is a business rule: ship_date should always follow order_date
SELECT order_date, ship_date 
FROM train
WHERE order_date > ship_date;

-- Check categorical columns for anomalies or redundancy
-- Checking for unique segments in the dataset (e.g., Consumer, Corporate)
SELECT DISTINCT segment
FROM train;

--  Check for negative sales values, which likely indicate data entry issues
SELECT *
FROM train
WHERE sales < 0;

-- Frequency analysis for categorical columns
-- Helps identify the distribution of ship modes, which can indicate anomalies or skewed data
SELECT ship_mode, COUNT(*) AS frequency
FROM train
GROUP BY ship_mode
ORDER BY frequency DESC;

-- Frequency analysis for segment column
SELECT segment, COUNT(*) AS frequency
FROM train
GROUP BY segment
ORDER BY frequency DESC;

-- Frequency analysis for region column
SELECT region, COUNT(*) AS frequency
FROM train
GROUP BY region
ORDER BY frequency DESC;

-- Frequency analysis for category column
SELECT category, COUNT(*) AS frequency
FROM train
GROUP BY category
ORDER BY frequency DESC;

-- Check for missing values in the sales column
SELECT COUNT(*) AS missing_sales
FROM train
WHERE sales IS NULL;

-- Check average, max, and min sales per state
SELECT state, ROUND(AVG(sales), 2) AS avg_sales, MAX(sales) AS max_sales, MIN(sales) AS min_sales
FROM train
GROUP BY state
ORDER BY avg_sales DESC;




