-- Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
SELECT 
    COUNT(order_id) AS total_order, 
    COUNT(DISTINCT user_id) AS total_user, 
    FORMAT_TIMESTAMP('%Y-%m', created_at) AS month_year
FROM 
    bigquery-public-data.thelook_ecommerce.orders
WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
AND status NOT IN ('Cancelled', 'Returned')  
GROUP BY month_year
ORDER BY month_year;
