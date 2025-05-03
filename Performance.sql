WITH s AS (
  SELECT 
    product_name, 
    year (order_date) AS fiscal_year, 
    sum(sales_amount) AS total_sales 
  FROM 
    [gold.fact_sales] s LEFT JOIN[gold.dim_products] p ON s.product_key = p.product_key 
  WHERE 
    year (order_date) IS NOT NULL 
  GROUP BY 
    product_name, 
    year (order_date)
) 
SELECT 
  product_name, 
  fiscal_year, 
  total_sales, 
  avg(total_sales) OVER (PARTITION BY product_name), 
  CASE WHEN total_sales > avg(total_sales) OVER (PARTITION BY product_name) THEN 'over avg' WHEN total_sales < avg(total_sales) OVER (PARTITION BY product_name) THEN 'under avg' ELSE 'avg' END AS comparing, 
  lag(total_sales) OVER (
    PARTITION BY product_name 
    ORDER BY 
      fiscal_year
  ) AS previous_year, 
  total_sales - lag(total_sales) OVER (
    PARTITION BY product_name 
    ORDER BY 
      fiscal_year
  ) AS increasing 
FROM 
  s
