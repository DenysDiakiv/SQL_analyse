CREATE VIEW customer_general AS with s AS (
  SELECT 
    s.order_number, 
    s.price, 
    s.order_date, 
    s.sales_amount, 
    s.quantity, 
    c.customer_key, 
    c.customer_number, 
    s.product_key, 
    concat(c.first_name, ' ', c.last_name) AS full_name, 
    DATEDIFF (
      year, 
      c.birthdate, 
      GETDATE ()
    ) AS age 
  FROM 
    [gold.fact_sales] s LEFT JOIN[gold.dim_customers] c ON s.customer_key = c.customer_key 
  WHERE 
    s.order_date IS NOT NULL
), 
st AS (
  SELECT 
    customer_key, 
    customer_number, 
    full_name, 
    age, 
    count(DISTINCT s.order_number) order_number, 
    sum(sales_amount) total_sales, 
    sum(quantity) total_quantity, 
    max(order_date) last_order, 
    count(DISTINCT product_key) product_count, 
    DATEDIFF (
      month, 
      min(order_date), 
      max(order_date)
    ) ac_length 
  FROM 
    s 
  GROUP BY 
    customer_key, 
    customer_number, 
    full_name, 
    age
) 
SELECT 
  customer_key, 
  customer_number, 
  full_name, 
  age, 
  CASE WHEN ac_length >= 12 
  AND total_sales > 5000 THEN 'VIP' WHEN ac_length >= 12 THEN 'Regular' ELSE 'New' END AS customer_type, 
  round(age, -1) age_group, 
  datediff (
    month, 
    last_order, 
    getdate ()
  ) recency, 
  CASE WHEN total_sales = 0 THEN 0 ELSE total_sales / order_number END AS avg_order_value, 
  CASE WHEN total_sales = 0 THEN 0 ELSE total_sales / ac_length END AS avg_month_sales, 
  order_number, 
  total_sales, 
  total_quantity, 
  last_order, 
  product_count, 
  ac_length 
FROM 
  st
