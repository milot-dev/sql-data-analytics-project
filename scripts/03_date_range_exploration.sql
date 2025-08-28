/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Find the date of the first and last order
-- How many years of sales are available
SELECT 
	MIN(order_date) first_order_date,
	MAX(order_date) last_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) timespan
FROM gold.fact_sales

-- Find the youngest and the oldest customer
SELECT
	MIN(birthdate) AS oldest_birthdate,
	DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
	MAX(birthdate) AS youngest_birthdate,
	DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers
