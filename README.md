# SQL EDA & Advanced Analysis Project

## Overview

This project focuses on analyzing sales data using **MySQL** to explore business performance, identify trends, and generate customer and product insights.

The project is divided into two main stages:

- **Exploratory Data Analysis (EDA)** — exploring the database structure, dimensions, dates, key business metrics, distributions, and rankings.
- **Advanced Analysis** — analyzing trends over time, cumulative performance, yearly product performance, category contributions, and customer segmentation.

The project also includes dedicated **Customer and Product Reports** that consolidate key metrics and KPIs into reusable SQL views.

## Tools & Technologies

- MySQL Server
- MySQL Workbench
- SQL

## Exploratory Data Analysis

The EDA phase covers:

### Database Exploration

- Database, tables and columns exploration

### Dimensions Exploration
  
- Customer geography (countries)
- Product categories, subcategories, and products

### Date Exploration

- First and last order dates
- Sales data range
- Youngest and oldest customers

### Key Business Metrics

- Total Revenue
- Quantity Sold
- Average Selling Price
- Total Orders
- Total Products
- Total Customers
- Active Customers

### Magnitude Analysis

- Customers by country
- Customers by gender
- Products by category
- Average product cost by category
- Revenue by category
- Revenue by customer
- Quantity sold by country

### Ranking Analysis

- Top 5 products by revenue
- 5 lowest-performing products
- Top 10 customers by revenue
- Customers with the fewest orders

## Advanced Analysis

The advanced analysis focuses on deeper business insights.

### Change Over Time Analysis

Analyzes monthly:

- Revenue
- Customers
- Quantity sold

### Cumulative Analysis

- Monthly revenue and running total revenue
- Year-to-date (YTD) revenue
- Monthly average selling price
- 3-month moving average price

### Yearly Product Analysis

Compares each product's yearly revenue with:

- Its average yearly revenue
- The previous year's revenue

### Part-to-Whole Analysis

- Revenue contribution by product category
- Customer distribution by country

### Segment Analysis

- Products segmented by cost range
- Customers segmented based on spending behavior and customer lifespan:
  - VIP
  - Regular
  - New

## Customer Report

The Customer Report creates a reusable SQL view containing customer-level metrics and behaviors.

Key metrics include:

- Customer information
- Age and age group
- Customer type
- Total orders
- Total quantity purchased
- Total revenue
- Total products
- Last order date
- Recency
- Average Order Value (AOV)
- Average monthly spending
- Customer lifespan

## Product Report

The Product Report creates a reusable SQL view containing product-level metrics and performance indicators.

Key metrics include:

- Product name
- Category and subcategory
- Cost
- Average selling price
- Total orders
- Total revenue
- Quantity sold
- Total customers
- Revenue level
- Recency
- Average Order Revenue (AOR)
- Average monthly revenue
- Product lifespan

## SQL Concepts Demonstrated

This project demonstrates practical use of:

- SELECT
- WHERE
- JOIN
- GROUP BY
- ORDER BY
- Aggregate Functions
- CASE Statements
- Date Functions
- TIMESTAMPDIFF()
- DATE_FORMAT()
- CTEs
- Subqueries
- Window Functions
- RANK()
- LAG()
- Running Totals
- Moving Averages
- UNION ALL
- SQL Views

## Project Objective

The objective of this project was to apply SQL to progressively explore sales data, perform advanced analysis, and build reusable customer and product reporting views.
