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

,youngest_oldest_age AS (
  SELECT * FROM youngest_age1
  UNION ALL 
  SELECT * FROM oldest_age1
)
SELECT gender, tag, COUNT(*) AS count
FROM youngest_oldest_age 
GROUP BY gender, tag;
https://drive.google.com/drive/u/0/folders/1AhgFxZsS8JKTg1OypA-cI7uOpxtK0dqt
