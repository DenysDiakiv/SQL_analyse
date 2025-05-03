SELECT 
  datetrunc (month, order_date) fiscal_month, 
  sum(sales_amount) AS total_sales, 
  count(DISTINCT customer_key) AS total_customer, 
  sum(quantity) AS total_quantity 
FROM 
  [gold.fact_sales] 
WHERE 
  order_date IS NOT NULL 
GROUP BY 
  datetrunc (month, order_date) 
ORDER BY 
  fiscal_month;
SELECT 
  year (order_date) AS fiscal_year, 
  sum(sales_amount) AS total_sales, 
  count(DISTINCT customer_key) AS total_customer, 
  sum(quantity) AS total_quantity 
FROM 
  [gold.fact_sales] 
WHERE 
  order_date IS NOT NULL 
GROUP BY 
  year (order_date) 
ORDER BY 
  fiscal_year