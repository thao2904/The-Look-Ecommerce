CREATE TEMP TABLE temp_user_age AS(
WITH youngest_data AS(
SELECT first_name,last_name,gender,age,
CASE WHEN age = MIN(age) OVER (PARTITION BY gender) THEN 'YOUNGEST'
ELSE ''END AS tag
FROM bigquery-public-data.thelook_ecommerce.users 
WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30')
, oldest_data AS(
SELECT first_name,last_name,gender,age,
CASE WHEN age = MAX(age) OVER (PARTITION BY gender) THEN 'OLDEST'
ELSE ''END AS tag
FROM bigquery-public-data.thelook_ecommerce.users 
WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30')
SELECT first_name, last_name, gender, age, tag FROM youngest_data
WHERE tag = 'YOUNGEST'
UNION DISTINCT 
SELECT first_name, last_name, gender, age, tag FROM oldest_data 
WHERE tag = 'OLDEST');

SELECT gender,SUM(CASE WHEN tag = 'YOUNGEST' THEN 1 ELSE 0 END) AS youngest_count,
SUM(CASE WHEN tag = 'OLDEST' THEN 1 ELSE 0 END) AS oldest_count
FROM temp_user_age
GROUP BY gender;
