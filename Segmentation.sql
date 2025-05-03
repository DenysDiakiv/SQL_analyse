SELECT 
  segment, 
  count(product_key) AS quantiy 
FROM 
  (
    SELECT 
      product_key, 
      product_name, 
      COST, 
      CASE WHEN COST <= 100 THEN 'Low' WHEN COST <= 500 THEN 'Medium' WHEN COST <= 1000 THEN 'Height' ELSE 'Premium' END AS segment 
    FROM 
      [gold.dim_products]
  ) AS t 
GROUP BY 
  segment 
ORDER BY 
  quantiy DESC;

SELECT 
  CASE WHEN ac_length >= 12 
  AND total_sales > 5000 THEN 'VIP' WHEN ac_length >= 12 THEN 'Regular' ELSE 'New' END AS customer_type, 
  count(customer_key) AS number_customer 
FROM 
  (
    SELECT 
      c.customer_key customer_key, 
      sum(sales_amount) total_sales, 
      DATEDIFF (
        month, 
        min(order_date), 
        max(order_date)
      ) ac_length
    FROM 
      [gold.fact_sales] s LEFT JOIN[gold.dim_customers] c ON c.customer_key = s.customer_key 
    GROUP BY 
      c.customer_key
  ) AS t 
GROUP BY 
  CASE WHEN ac_length >= 12 
  AND total_sales > 5000 THEN 'VIP' WHEN ac_length >= 12 THEN 'Regular' ELSE 'New' END 
ORDER BY 
  number_customer DESC;