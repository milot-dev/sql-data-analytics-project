/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/


/* Segment products into cost ranges and 
count how many products fall into each segment */
WITH product_segments AS (
SELECT
	product_key,
	product_name,
	cost,
	CASE WHEN cost > 500 THEN 'High value'
		 WHEN cost > 250 THEN 'Medium value'
		 ELSE 'Low value'
	END AS cost_range
FROM gold.dim_products
)
SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC

/* Group customers into three segments based on their spending behavior
 - VIP : at least 12 months of history and spending more than $5000.
 - Regular : at least 12 months of history but spending $5000 or less.
 - New : lifespan less than 12 months. */
WITH customer_lifespan_spending AS (
SELECT
	c.customer_key,
	DATEDIFF(month, MIN(s.order_date), MAX(s.order_date)) AS lifespan,
	SUM(s.sales_amount) AS total_spending
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)
,
roles_by_spending AS (
SELECT
	customer_key,
	CASE
		WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS user_role
FROM customer_lifespan_spending
)
SELECT
	user_role,
	COUNT(customer_key) AS total_customers
FROM roles_by_spending
GROUP BY user_role
ORDER BY total_customers DESC

