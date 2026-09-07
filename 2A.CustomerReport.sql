/*
===============================================================
						Customer Report
===============================================================

Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
*/

CREATE OR REPLACE VIEW report_customer AS
WITH base_query AS
-- Base Query: Retrieves core columns from sales and customers
(SELECT
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	c.customer_key,
    c.customer_number,
	CONCAT(c.first_name, " ", c.last_name) AS customer_name,
	c.gender,
	TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) AS age
FROM sales s
JOIN customers c on c.customer_key = s.customer_key),

customer_aggregation AS
-- Customer Aggregation: Summarizes key metrics at customer level
(SELECT
	customer_key,
	customer_number,
	customer_name,
	gender,
    age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(quantity) AS total_quantity_purchased,
	SUM(sales_amount) AS total_revenue,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	TIMESTAMPDIFF(MONTH, MIN(order_date) , MAX(order_date)) AS lifespan
FROM base_query
GROUP BY
	customer_key,	
	customer_number,
	customer_name,
	gender,
    age)
    
-- Final Query: Combines all customer results into one output
SELECT
	customer_key,
	customer_number,
	customer_name,
	gender,
    age,
	CASE WHEN age < 20 THEN "Under 20"
		 WHEN age <= 30 THEN "20 - 30"
         WHEN age <= 40 THEN "30 - 40"
         WHEN age <= 50 THEN "40 - 50"
         WHEN age <= 60 THEN "50 - 60"
         ELSE "Above 60"
	END AS age_group,
    CASE WHEN lifespan >= 12 AND total_revenue > 5000 THEN "VIP"
		 WHEN lifespan >= 12 AND total_revenue <= 5000 THEN "Regular"
		 WHEN lifespan < 12 THEN "New"
	END AS customer_type,
	total_orders,
	total_quantity_purchased,
	total_revenue,
	total_products,
	last_order_date,
    TIMESTAMPDIFF(MONTH, last_order_date, CURDATE()) AS recency_in_month,
-- AOV calculation
    CASE WHEN total_orders = 0 THEN 0
		ELSE ROUND(total_revenue / total_orders , 2)
	END AS AOV,
-- Avg. Monthly Spending calculation
	CASE WHEN lifespan = 0 THEN total_revenue
		 ELSE ROUND(total_revenue / lifespan , 2)
	END AS avg_monthly_spending,
	lifespan
FROM customer_aggregation;


-- Example Use of report_customer View:
-- Analyze customer metrics by age group

SELECT
	age_group,
	COUNT(customer_key) AS total_customers,
	ROUND(AVG(aov),2) AS AOV,
	ROUND(AVG(avg_monthly_spending),2) AS avg_monthly_spending 
FROM report_customer
GROUP BY age_group;