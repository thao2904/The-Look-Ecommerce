/*Top 5 sản phẩm mỗi tháng.
Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month
Hint: Sử dụng hàm dense_rank()*/

WITH rank_product AS (
    SELECT 
        a.product_id,
        b.name AS product_name, 
        ROUND(SUM(a.sale_price), 2) AS sales, 
        ROUND(b.cost, 2) AS cost, 
        ROUND(SUM(a.sale_price - b.cost), 2) AS profit, 
        FORMAT_DATE('%Y-%m', a.created_at) AS month_year,
        DENSE_RANK() OVER(
            PARTITION BY FORMAT_DATE('%Y-%m', a.created_at) 
            ORDER BY SUM(a.sale_price - b.cost) DESC
        ) AS rank_per_month
    FROM 
        bigquery-public-data.thelook_ecommerce.order_items a
    JOIN 
        bigquery-public-data.thelook_ecommerce.products b
    ON 
        a.product_id = b.id
    GROUP BY 
        a.product_id, b.name, a.created_at, b.cost
)
SELECT 
    product_id, product_name, sales, cost, profit, month_year, rank_per_month
FROM 
    rank_product
WHERE 
    rank_per_month <= 5
ORDER BY 
    month_year, rank_per_month;
