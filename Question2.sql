/*Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng 
( Từ 1/2019-4/2022)*/
SELECT COUNT(DISTINCT a.user_id) AS distinct_users, 
ROUND(SUM(b.sale_price)/COUNT(a.order_id),2) AS average_order_value,
FORMAT_DATE('%Y-%m', a.created_at) AS month_year
FROM bigquery-public-data.thelook_ecommerce.orders AS a 
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.order_id = b.order_id
WHERE a.created_at BETWEEN '2019-01-01' AND '2022-04-30'
AND a.status NOT IN ('Cancelled', 'Returned')  
GROUP BY month_year
ORDER BY month_year
--Link file output:https://drive.google.com/drive/u/0/folders/1AhgFxZsS8JKTg1OypA-cI7uOpxtK0dqt
