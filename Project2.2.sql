SELECT 
    FORMAT_DATE('%Y-%m', a.created_at) AS month,
    b.category AS product_category, 
    ROUND(SUM(a.sale_price), 2) AS TPV,
    COUNT(a.order_id) AS TPO,
    LAG(ROUND(SUM(a.sale_price), 2)) OVER(PARTITION BY b.category ORDER BY FORMAT_DATE('%Y-%m', a.created_at)) AS previous_revenue, 
    LAG(COUNT(a.order_id)) OVER(PARTITION BY b.category ORDER BY FORMAT_DATE('%Y-%m', a.created_at)) AS previous_order,
    ROUND(SUM(b.cost), 2) AS total_cost,
    ROUND(SUM(a.sale_price) - SUM(b.cost), 2) AS total_profit,
    ROUND((SUM(a.sale_price) - SUM(b.cost)) / SUM(b.cost), 2) AS profit_to_cost_ratio
FROM 
    `bigquery-public-data.thelook_ecommerce.order_items` a
JOIN 
    `bigquery-public-data.thelook_ecommerce.products` b 
ON 
    a.id = b.id
GROUP BY 
    FORMAT_DATE('%Y-%m', a.created_at), b.category
ORDER BY 
    FORMAT_DATE('%Y-%m', a.created_at);
