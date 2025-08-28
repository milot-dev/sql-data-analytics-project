
/*
===============================================================================================
Product Report
===============================================================================================
Purpose:
	- This report consolidates key product metrics and behaviors

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify High-Perfomers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
===============================================================================================
*/
CREATE VIEW gold.report_products AS
WITH base_query AS (
-- 1) Base query with additional information
SELECT 
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost,
	s.customer_key,
	s.order_number,
	s.order_date,
	s.sales_amount,
	s.quantity
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
WHERE s.order_date IS NOT NULL
)
,
aggregations_product AS (
-- 2) Product Aggregations: Summarizes key metrics at the product level
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	COUNT(DISTINCT order_number) AS total_orders,
	MAX(order_date) AS last_sale_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customers
FROM base_query
GROUP BY
	product_key,
	product_name,
	category,
	subcategory,
	cost
)
-- 3) Final Query: Combines all product results into one output
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(month, last_sale_date, GETDATE()) AS recency_in_months,
	CASE 
		WHEN total_sales > 1000000 THEN 'High-Performers'
		WHEN total_sales > 500000 THEN 'Mid-Range'
		ELSE 'Low-Performers'
	END AS segment_revenue,
	last_sale_date,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	-- Compuate average order revenue  (AOR)
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
	END AS avg_order_revenue,
	-- Compuate average monthly revenue 
	CASE WHEN lifespan = 0 THEN 0
		 ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM aggregations_product
