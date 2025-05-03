  WITH s AS (
  SELECT 
    datetrunc (month, order_date) fiscal_month, 
    sum(sales_amount) AS total_sales 
  FROM 
    [gold.fact_sales] 
  WHERE 
    order_date IS NOT NULL 
  GROUP BY 
    datetrunc (month, order_date)
) 
SELECT 
  fiscal_month, 
  total_sales, 
  avg(total_sales) OVER (
    ORDER BY 
      fiscal_month ROWS BETWEEN 4 PRECEDING 
      AND CURRENT ROW
  ) AS movingavg_sales 
FROM 
  s;
SELECT 
  fiscal_month, 
  total_sales, 
  sum(total_sales) OVER (
    ORDER BY 
      fiscal_month
  ) AS cum_sales 
FROM 
  (
    SELECT 
      datetrunc (month, order_date) fiscal_month, 
      sum(sales_amount) AS total_sales 
    FROM 
      [gold.fact_sales] 
    WHERE 
      order_date IS NOT NULL 
    GROUP BY 
      datetrunc (month, order_date)
  ) AS t;
