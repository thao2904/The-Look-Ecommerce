/*Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)
Hint: Sử dụng UNION các KH tuổi trẻ nhất với các KH tuổi trẻ nhất 
tìm các KH tuổi trẻ nhất và gán tag ‘youngest’  
tìm các KH tuổi trẻ nhất và gán tag ‘oldest’ 
Insight là gì? (Trẻ nhất là bao nhiêu tuổi, số lượng bao nhiêu? Lớn nhất là bao nhiêu tuổi, số lượng bao nhiêu)*/
Note: Lưu output vào temp table rồi đếm số lượng tương ứng 

WITH user_age AS (
  SELECT gender, 
         MIN(age) as youngest_age, 
         MAX(age) as oldest_age
  FROM bigquery-public-data.thelook_ecommerce.users
  GROUP BY gender
),
youngest_age1 AS (
  SELECT a.first_name, a.last_name, a.age, a.gender, 'youngest' AS tag
  FROM bigquery-public-data.thelook_ecommerce.users AS a
  JOIN user_age AS b ON a.gender = b.gender
  WHERE a.age = b.youngest_age
    AND a.created_at BETWEEN '2019-01-01' AND '2022-04-30'
),
oldest_age1 AS (
  SELECT a.first_name, a.last_name, a.age, a.gender, 'oldest' AS tag
  FROM bigquery-public-data.thelook_ecommerce.users AS a
  JOIN user_age AS b ON a.gender = b.gender
  WHERE a.age = b.oldest_age
    AND a.created_at BETWEEN '2019-01-01' AND '2022-04-30'
)
-- Counting the youngest and oldest users by gender
,youngest_oldest_age AS (
  SELECT * FROM youngest_age1
  UNION ALL 
  SELECT * FROM oldest_age1
)
SELECT gender, tag, COUNT(*) AS count
FROM youngest_oldest_age 
GROUP BY gender, tag;
