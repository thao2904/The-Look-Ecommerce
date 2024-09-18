/*
Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue*/
/*
Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue*/
SELECT 
FORMAT_TIMESTAMP('%Y-%m-%d', a.created_at) AS date,
c.category AS product_categories, 
ROUND(SUM(a.sale_price * b.num_of_item),2) as revenue
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.orders AS b ON a.order_id = b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c ON a.id = c.id
WHERE DATE(a.created_at) BETWEEN DATE_SUB(DATE('2022-04-15'), INTERVAL 3 MONTH) AND DATE('2022-04-15')
GROUP BY  c.category, a.created_at 
ORDER BY a.created_at
