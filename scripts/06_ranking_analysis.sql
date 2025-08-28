/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 Products generate the highest revenue?
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s 
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

-- Subquery with window functions
SELECT *
FROM (
	SELECT
		p.product_name,
		SUM(s.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales s 
	LEFT JOIN gold.dim_products p
	ON p.product_key = s.product_key
	GROUP BY p.product_name)t 
WHERE rank_products <= 5

-- What are the 5 worst-performing products in terms of sales
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s 
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	c.customer_id,
	c.first_name,
	c.last_name,
	SUM(sales_amount) AS total_revenue
FROM gold.fact_sales s 
LEFT JOIN gold.dim_customers c
ON c.customer_key = s.customer_key
GROUP BY 
	c.customer_id, 
	c.first_name, 
	c.last_name
ORDER BY total_revenue DESC

-- The 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_id,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT s.order_number) AS total_orders_placed
FROM gold.fact_sales s 
LEFT JOIN gold.dim_customers c
ON c.customer_key = s.customer_key
GROUP BY 
	c.customer_id, 
	c.first_name, 
	c.last_name
ORDER BY total_orders_placed ASC
