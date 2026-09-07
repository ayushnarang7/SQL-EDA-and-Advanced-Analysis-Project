		-- 1.Change-Over-Time Trends 

-- Calculate Total Revenue, Total Customers, Quantity Sold over time

SELECT
	YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_revenue,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS quantity_sold
FROM
    sales
GROUP BY YEAR(order_date),
    MONTH(order_date)
ORDER BY YEAR(order_date),
    MONTH(order_date);
    
    -- OR
    
SELECT
	DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
    SUM(sales_amount) AS total_revenue,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS quantity_sold
FROM
    sales
GROUP BY order_month
ORDER BY order_month;


		-- 2.Cumulative Analysis
        
-- Calculate the total revenue per month
-- and the running total of revenue over time

SELECT
order_month,
total_revenue,
SUM(total_revenue) OVER (ORDER BY order_month) AS running_total_revenue
FROM
(SELECT
DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
SUM(sales_amount) AS total_revenue
FROM sales
GROUP BY order_month) a; 

-- Calculate the total revenue per month
-- and the running yearly revenue (YTD)

SELECT
order_month,
total_revenue,
SUM(total_revenue) OVER (PARTITION BY order_year ORDER BY order_month) AS running_total_revenue
FROM
(SELECT
YEAR(order_date) AS order_year,
DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
SUM(sales_amount) AS total_revenue
FROM sales
GROUP BY order_year, order_month) a;

-- Calculate the average price per month
-- and the 3-month moving average price

SELECT
order_month,
avg_price,
ROUND(AVG(avg_price) OVER (ORDER BY order_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS 3m_moving_avg_price
FROM
(SELECT
DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
AVG(price) as avg_price
FROM sales
GROUP BY order_month) a;

/* Analyze yearly product revenue by comparing
   each year's revenue to the product's average revenue
   and the previous year's revenue */

SELECT
*,
ROUND(AVG(a.current_revenue) OVER(PARTITION BY product_name)) AS avg_revenue,
current_revenue - ROUND(AVG(a.current_revenue) OVER(PARTITION BY product_name)) AS gap_avg,
CASE WHEN current_revenue - ROUND(AVG(a.current_revenue) OVER(PARTITION BY product_name)) > 0 THEN "Above Avg."
	 WHEN current_revenue - ROUND(AVG(a.current_revenue) OVER(PARTITION BY product_name)) < 0 THEN "Below Avg."
     ELSE "Avg."
END AS avg_change,
LAG(a.current_revenue) OVER(PARTITION BY product_name ORDER BY year) AS previous_year_revenue,
current_revenue - LAG(a.current_revenue) OVER(PARTITION BY product_name ORDER BY year) AS gap_prev_year,
CASE WHEN current_revenue - LAG(a.current_revenue) OVER(PARTITION BY product_name ORDER BY year) > 0 THEN "Increase"
	 WHEN current_revenue - LAG(a.current_revenue) OVER(PARTITION BY product_name ORDER BY year) < 0 THEN "Decrease"
	 ELSE "No Change"
END AS py_change
FROM
(SELECT
YEAR(s.order_date) AS year,
p.product_name,
SUM(s.sales_amount) AS current_revenue
FROM sales s
JOIN products p ON s.product_key = p.product_key
GROUP BY year, p.product_name) a;
 
 
		-- 4.Part-To-Whole Analysis
        
-- Which categories contribute the most to overall sales?

WITH category_revenue AS
(SELECT
p.category,
SUM(s.sales_amount) AS total_revenue
FROM 
products p 
JOIN sales s on p.product_key = s.product_key
GROUP BY p.category) 
SELECT
*,
CONCAT(ROUND(total_revenue / SUM(total_revenue) OVER() * 100, 2), "%") AS revenue_percentage
FROM category_revenue
ORDER BY total_revenue DESC;

-- Distribution of customers by country

WITH customers_by_country AS
(SELECT
country,
COUNT(customer_key) AS total_customers
FROM customers
WHERE country != "n/a"
GROUP BY country)
SELECT
*,
CONCAT(ROUND(total_customers / SUM(total_customers) OVER() * 100, 2), "%") AS customer_percentage
FROM customers_by_country
ORDER BY total_customers DESC;


		-- 5.Segment Analysis
        
-- Segment products into cost ranges and count how many products fall into each category

SELECT
CASE WHEN cost < 100 THEN "Below 100"
	 WHEN cost <= 500 THEN "100 - 500"
     WHEN cost <= 1000 THEN "501 - 1000"
     ELSE "Above 1000"
END AS cost_range,
COUNT(DISTINCT product_key) AS total_products
FROM products
GROUP BY cost_range
ORDER BY total_products DESC;


-- Divide the total customers into 3 segments based on their spending behavior

SELECT
customer_type,
SUM(total_customers) as total_customers
FROM
(SELECT
CASE WHEN TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) >= 12 AND SUM(sales_amount) > 5000 THEN "VIP"
	 WHEN TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) >= 12 AND SUM(sales_amount) <= 5000 THEN "Regular"
     ELSE "New"
END AS customer_type,
COUNT(DISTINCT customer_key) AS total_customers
FROM sales
GROUP BY customer_key) a
GROUP BY a.customer_type;