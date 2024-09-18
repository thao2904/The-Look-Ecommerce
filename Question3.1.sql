WITH 
user_date AS(
SELECT gender, MIN(age) AS youngest_age, MAX(age) AS oldest_age
FROM bigquery-public-data.thelook_ecommerce.users
GROUP BY gender
),

youngest_age AS(
SELECT 
a.gender, a.age, COUNT(*) AS count,
'youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users AS a
JOIN user_date AS b ON a.gender = b.gender
WHERE a.age = b.youngest_age
AND a.created_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY a.gender, a.age
), 

oldest_age AS(
SELECT 
a.gender, a.age, COUNT(*) AS count,
'olest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users AS a
JOIN user_date AS b ON a.gender = b.gender
WHERE a.age = b.oldest_age
AND a.created_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY a.gender, a.age
)

SELECT * FROM youngest_age
UNION ALL
SELECT * FROM oldest_age
