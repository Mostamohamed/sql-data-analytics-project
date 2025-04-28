/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - LEAD(): Accesses data from next rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/
/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
WITH yearly_product_sales AS (
SELECT 
	YEAR(f.order_date) AS order_year,
	p.product_name AS product_name,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON f.product_key=p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY 
	YEAR(f.order_date),
	p.product_name
)
SELECT 
	order_year,
	product_name,
	current_sales,
	-- Year-over-Year Analysis
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
	CASE
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END py_change,

	current_sales,
	LEAD(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS ny_sales,
	current_sales - LEAD(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS ny_py,
	CASE
		WHEN current_sales - LEAD(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		WHEN current_sales - LEAD(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END ny_change,


	AVG(current_sales) OVER(PARTITION BY product_name)  avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS   diff_avg,
	CASE
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END avg_change
FROM yearly_product_sales
ORDER BY product_name,order_year


/* Analyze the monthly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
WITH monthly_product_sales AS (
SELECT 
	YEAR(f.order_date) AS order_year,
	MONTH(f.order_date) AS order_month,
	p.product_name AS product_name,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p
ON f.product_key=p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY 
	MONTH(f.order_date),
	p.product_name,
	YEAR(f.order_date)
)
SELECT 
	order_year,
	order_month,
	product_name,
	current_sales,
	-- Month-over-Month Analysis
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) AS pm_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) AS diff_pm,
	CASE
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END pm_change,

	current_sales,
	LEAD(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) AS nm_sales,
	current_sales - LEAD(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) AS nm_pm,
	CASE
		WHEN current_sales - LEAD(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) > 0 THEN 'Increase'
		WHEN current_sales - LEAD(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END nm_change,


	AVG(current_sales) OVER(PARTITION BY product_name)  avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS   diff_avg,
	CASE
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END avg_change
FROM monthly_product_sales
ORDER BY product_name,order_year,order_month
