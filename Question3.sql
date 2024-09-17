-- Tìm các khách hàng trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính 
-- CTE này tìm độ tuổi nhỏ nhất và lớn nhất theo từng giới tính
-- CTE này đếm số lượng người dùng có độ tuổi nhỏ nhất theo từng giới tính trong khoảng thời gian từ 01-2019 đến 04-2022
-- CTE này đếm số lượng người dùng có độ tuổi lớn nhất theo từng giới tính trong khoảng thời gian từ 01-2019 đến 04-2022
WITH user_age AS
(SELECT gender, 
MIN(age) as youngest_age, MAX(age) as oldest_age
FROM bigquery-public-data.thelook_ecommerce.users
GROUP BY gender)
, youngest_age1 AS
(SELECT a.first_name, a.last_name, a.age, a.gender, 'youngest'AS tag
FROM bigquery-public-data.thelook_ecommerce.users a
JOIN user_age AS b ON a.gender = b.gender
WHERE a.age = b.youngest_age
AND a.created_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY a.age, a.gender,a.first_name, a.last_name)
, oldest_age1 AS
(SELECT c.first_name, c.last_name, c.age, c.gender, 'oldest'AS tag
FROM bigquery-public-data.thelook_ecommerce.users c
JOIN user_age AS b ON c.gender = b.gender
WHERE c.age = b.oldest_age
AND c.created_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY c.age, c.gender,c.first_name, c.last_name)
