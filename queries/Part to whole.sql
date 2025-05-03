SELECT 
  category, 
  total_sales, 
  sum(total_sales) OVER () AS amount, 
  round(cast(total_sales AS float) / sum(total_sales) OVER () * 100,2) AS percenage 
FROM 
  (
    SELECT 
      category, 
      sum(sales_amount) AS total_sales 
    FROM 
      [gold.fact_sales] s LEFT JOIN[gold.dim_products] AS p ON s.product_key = p.product_key 
    GROUP BY 
      category
  ) AS t
ORDER BY total_sales DESC;
