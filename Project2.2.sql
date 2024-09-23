WITH aggregated_data AS (
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
FROM aggregated_data
ORDER BY month;
