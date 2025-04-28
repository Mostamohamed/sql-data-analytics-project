/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the total Sales
SELECT SUM(sales_amount)  AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity)  AS total_quantity FROM gold.fact_sales

--find the average selling price
SELECT AVG(price)  AS average_price FROM gold.fact_sales

--find the total numbers of Orders
SELECT COUNT(order_number)  AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number)  AS total_orders FROM gold.fact_sales -- more accurate number of orders

--find the total numbers of Products
SELECT COUNT(product_key)  AS total_products FROM gold.dim_products
SELECT COUNT(DISTINCT product_key)  AS total_products FROM gold.dim_products --so no there duplicate

SELECT COUNT(product_name)  AS total_products FROM gold.dim_products
SELECT COUNT(DISTINCT product_name)  AS total_products FROM gold.dim_products

--find the total numbers of Customers
SELECT COUNT(customer_key)  AS total_customers FROM gold.dim_customers

--find the total numbers of Customers that has placed an order
SELECT COUNT(DISTINCT customer_key)  AS total_customers FROM gold.fact_sales



-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name ,SUM(sales_amount)  AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name ,SUM(quantity)  AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name ,AVG(price)  AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders' AS measure_name ,COUNT(DISTINCT order_number)  AS measure_value FROM gold.fact_sales 
UNION ALL
SELECT 'Total N. Orders' AS measure_name ,COUNT(product_key)  AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total N. Products' AS measure_name ,COUNT(customer_key)  AS measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total N. Customers' AS measure_name ,COUNT(customer_key)  AS measure_value FROM gold.fact_sales
