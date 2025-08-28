/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
-- Explore All Countries our customers come from.
SELECT DISTINCT country FROM gold.dim_customers ORDER BY country;

-- Explore All Categories
SELECT DISTINCT 
  category, 
  subcategory, 
  product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
