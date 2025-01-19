SELECT
  LPAD(CAST(EXTRACT(MONTH FROM creation_date) AS STRING), 2, '0') AS Month_num,
  FORMAT_DATE('%b', DATE(2022, EXTRACT(MONTH FROM creation_date), 1)) AS Month,
  ROUND(SAFE_DIVIDE(
    SUM(CASE WHEN LOWER(tags) LIKE '%python%' THEN 1 ELSE 0 END),
    COUNT(*)
  ), 4) AS Proportion
FROM `bigquery-public-data.stackoverflow.posts_questions`
WHERE EXTRACT(YEAR FROM creation_date) = 2022
GROUP BY Month_num, Month
ORDER BY Month_num;