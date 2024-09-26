WITH sale_data AS (
  SELECT 
      FORMAT_DATE('%Y-%m', a.created_at) AS month,
      b.category AS product_category, 
      ROUND(SUM(a.sale_price), 2) AS TPV,
      COUNT(a.order_id) AS TPO,
      ROUND(SUM(b.cost), 2) AS total_cost,
      ROUND(SUM(a.sale_price) - SUM(b.cost), 2) AS total_profit,
      ROUND((SUM(a.sale_price) - SUM(b.cost)) / SUM(b.cost), 2) AS profit_to_cost_ratio
  FROM bigquery-public-data.thelook_ecommerce.order_items a
  JOIN bigquery-public-data.thelook_ecommerce.products b
  ON a.id = b.id
  GROUP BY month, b.category
)
SELECT 
    month,
    product_category,
    TPV,
    TPO,
    LAG(TPV) OVER(PARTITION BY product_category ORDER BY month) AS previous_revenue,
    LAG(TPO) OVER(PARTITION BY product_category ORDER BY month) AS previous_order,
    total_cost,
    total_profit,
    profit_to_cost_ratio
FROM sale_data
ORDER BY month;


-- TẠO COHORT:
WITH ecommerce_index as(
SELECT 
    user_id, 
    amount, 
    FORMAT_DATE('%Y-%m', DATE(first_purchase_date)) AS cohort_date,  
    created_at, 
    (EXTRACT(YEAR FROM created_at) - EXTRACT(YEAR FROM first_purchase_date)) * 12 + 
    (EXTRACT(MONTH FROM created_at) - EXTRACT(MONTH FROM first_purchase_date)) + 1 AS index
FROM (
    SELECT 
        a.user_id, 
        a.num_of_item * b.sale_price AS amount,  
        MIN(a.created_at) OVER (PARTITION BY a.user_id) AS first_purchase_date, 
        a.created_at
    FROM bigquery-public-data.thelook_ecommerce.orders a
    JOIN bigquery-public-data.thelook_ecommerce.order_items b 
    ON a.order_id = b.order_id 
    WHERE a.status NOT IN ('Cancelled', 'Returned')
) AS c)

SELECT cohort_date, 
index, 
COUNT(DISTINCT user_id) AS customer_id,
ROUND(SUM(amount),2) AS revenue
from ecommerce_index
WHERE index BETWEEN 1 AND 4 
GROUP BY cohort_date, index
ORDER BY cohort_date, index;
