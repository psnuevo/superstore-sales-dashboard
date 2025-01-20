-- Exploratory Data Analysis (EDA)

-- Preview the first few rows of the dataset to understand the structure
SELECT *
FROM train
LIMIT 10;

-- Understand the table schema (column names, data types, etc.)
DESCRIBE train;

-- Basic summary statistics (min, max, average, standard deviation) for the sales column
-- This helps identify the distribution and detect anomalies.
SELECT 
    MIN(sales) AS min_sales,
    MAX(sales) AS max_sales,
    ROUND(AVG(sales), 2) AS avg_sales,
    ROUND(STDDEV(sales), 2) AS stddev_sales,
    COUNT(*) AS total_rows
FROM train;

-- Count orders by date to check the dataset's time coverage and distribution
SELECT order_date, COUNT(*) AS order_count
FROM train
GROUP BY order_date
ORDER BY order_date;

--Analyze frequency and percentage for categorical columns
SELECT ship_mode, 
       COUNT(*) AS frequency, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM train), 2) AS percentage
FROM train
GROUP BY ship_mode
ORDER BY frequency DESC;

SELECT segment, 
       COUNT(*) AS frequency, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM train), 2) AS percentage
FROM train
GROUP BY segment
ORDER BY frequency DESC;

SELECT region, 
       COUNT(*) AS frequency, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM train), 2) AS percentage
FROM train
GROUP BY region
ORDER BY frequency DESC;

SELECT category, 
       COUNT(*) AS frequency, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM train), 2) AS percentage
FROM train
GROUP BY category
ORDER BY frequency DESC;

SELECT sub_category, 
       COUNT(*) AS frequency, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM train), 2) AS percentage
FROM train
GROUP BY sub_category
ORDER BY frequency DESC;

-- Analyze sales ranges to understand the distribution of sales
-- Categorize sales into bins
SELECT 
    CASE 
        WHEN sales < 50 THEN '0-50'
        WHEN sales BETWEEN 50 AND 100 THEN '50-100'
        WHEN sales BETWEEN 100 AND 500 THEN '100-500'
        ELSE '500+' 
    END AS sales_range,
    COUNT(*) AS frequency,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM train), 2) AS percentage
FROM train
GROUP BY sales_range
ORDER BY frequency DESC;

-- Average, max, and min sales per state
-- Helps identify top-performing and underperforming states
SELECT state, 
       ROUND(AVG(sales), 2) AS avg_sales, 
       MAX(sales) AS max_sales, 
       MIN(sales) AS min_sales
FROM train
GROUP BY state
ORDER BY avg_sales DESC;

-- Analyze total sales by categorical columns 
SELECT ship_mode, 
       ROUND(SUM(sales), 2) AS total_sales
FROM train
GROUP BY ship_mode
ORDER BY total_sales DESC;

SELECT segment, 
       ROUND(SUM(sales), 2) AS total_sales
FROM train
GROUP BY segment
ORDER BY total_sales DESC;

SELECT region, 
       ROUND(SUM(sales), 2) AS total_sales
FROM train
GROUP BY region
ORDER BY total_sales DESC;

SELECT state, 
       ROUND(SUM(sales), 2) AS total_sales
FROM train
GROUP BY state
ORDER BY total_sales DESC;

SELECT category, 
       ROUND(SUM(sales), 2) AS total_sales
FROM train
GROUP BY category
ORDER BY total_sales DESC;

-- Orders by month (time series analysis)
-- Aggregate orders by year and month to observe trends
SELECT DATE_FORMAT(order_date, '%Y-%m') AS `year_month`, 
       COUNT(*) AS order_count
FROM train
GROUP BY `year_month`
ORDER BY `year_month`;

-- Orders by day of the week
-- Useful for understanding peak order days
SELECT DAYNAME(order_date) AS day_of_week, 
       COUNT(*) AS order_count
FROM train
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- Average sales and shipping duration by region
-- Provides insights into sales performance and delivery efficiency
SELECT region, 
       ROUND(AVG(sales), 2) AS avg_sales, 
       ROUND(AVG(ship_date - order_date), 2) AS avg_shipping_duration
FROM train
GROUP BY region
ORDER BY avg_sales DESC;

-- Top 10 products by total sales
-- Highlights the best-selling products
SELECT product_name, 
       ROUND(SUM(sales), 2) AS total_sales
FROM train
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 customers by total sales
SELECT customer_name, 
       ROUND(SUM(sales), 2) AS total_sales
FROM train
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;