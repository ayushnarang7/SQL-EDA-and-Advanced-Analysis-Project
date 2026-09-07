/*
===============================================================
						Product Report
===============================================================

Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
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
*/

CREATE OR REPLACE VIEW report_product AS
WITH base_query AS
-- Base Query: Retrieves core columns from sales and products
(SELECT
	s.order_number,
	s.order_date,
	s.customer_key,
	s.sales_amount,
	s.quantity,
	s.price,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM sales s
JOIN products p on s.product_key = p.product_key),

product_aggregation AS
-- Product Aggregation: Summarizes key metrics at product level
(SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_revenue,
	SUM(quantity) AS quantity_sold,
	COUNT(DISTINCT customer_key) AS total_customers,
    MAX(order_date) AS last_order_date,
	TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	ROUND(AVG(price), 2) AS avg_selling_price
FROM base_query
GROUP BY
	product_key,
	product_name,
	category,
	subcategory,
	cost)
    
-- Final Query: Combines all product results into one output
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
    avg_selling_price,
	total_orders,
	total_revenue,
	quantity_sold,
	total_customers,
    CASE WHEN total_revenue <= 20000 THEN "Low"
		 WHEN total_revenue <= 100000 THEN "Mid"
         ELSE "High"
	END AS revenue_level,
    TIMESTAMPDIFF(MONTH, last_order_date, CURDATE()) AS recency_in_months,
-- AOR calculation
    CASE WHEN total_orders = 0 THEN 0
		 ELSE ROUND(total_revenue / total_orders , 2)
	END AS avg_order_revenue,
-- Avg. Monthly Revenue calculation
	CASE WHEN lifespan = 0 THEN total_revenue
		 ELSE ROUND(total_revenue / lifespan , 2)
	END AS avg_monthly_revenue,
	lifespan
FROM product_aggregation;


