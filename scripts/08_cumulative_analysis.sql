/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over All time 
SELECT
	order_date ,
	total_sales,
-- Window function
	SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales
FROM(
SELECT 
	DATETRUNC(month,order_date) AS order_date,
	SUM(sales_amount)  AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
) t

-- Calculate the total sales per month 
-- and the running total of sales over time with uasing partition to calc every month
SELECT
	order_date ,
	total_sales,
-- Window function
	SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM(
SELECT 
	DATETRUNC(month,order_date) AS order_date,
	SUM(sales_amount)  AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
) t


-- Calculate the total sales per year
-- and the running total of sales over time every year
SELECT
	order_date ,
	total_sales,
-- Window function
	SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales
FROM(
SELECT 
	DATETRUNC(year,order_date) AS order_date,
	SUM(sales_amount)  AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year,order_date)
) t



-- Calculate the average price per year
-- and the moving average price over time every year
SELECT
	order_date ,
	avg_price,
-- Window function
	SUM(avg_price) OVER(ORDER BY order_date) AS moving_average_price
FROM(
SELECT 
	DATETRUNC(year,order_date) AS order_date,
	AVG(price)  AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year,order_date)
) t

-- merge two query in one 
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t
