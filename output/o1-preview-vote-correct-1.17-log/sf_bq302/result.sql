SELECT
  TO_CHAR(EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("creation_date" / 1e6)), '00') AS "Month_num",
  TO_CHAR(TO_TIMESTAMP_NTZ("creation_date" / 1e6), 'Mon') AS "Month",
  ROUND(
    SUM(CASE WHEN '|' || LOWER("tags") || '|' LIKE '%|python|%' THEN 1 ELSE 0 END)::FLOAT / COUNT(*),
    4
  ) AS "Proportion"
FROM
  STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
WHERE
  TO_TIMESTAMP_NTZ("creation_date" / 1e6) >= '2022-01-01'::TIMESTAMP_NTZ
  AND TO_TIMESTAMP_NTZ("creation_date" / 1e6) < '2023-01-01'::TIMESTAMP_NTZ
GROUP BY
  "Month_num", "Month"
ORDER BY
  "Month_num";