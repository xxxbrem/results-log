SELECT
  LPAD(EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("creation_date" / 1e6))::VARCHAR, 2, '0') AS "Month_num",
  TO_CHAR(TO_TIMESTAMP_NTZ("creation_date" / 1e6), 'Month') AS "Month",
  ROUND(
    SUM(CASE WHEN "tags" IS NOT NULL AND "tags" <> '' AND ('|' || "tags" || '|') LIKE '%|python|%' THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
    4
  ) AS "Proportion"
FROM
  "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS"
WHERE
  TO_TIMESTAMP_NTZ("creation_date" / 1e6) >= DATE '2022-01-01'
  AND TO_TIMESTAMP_NTZ("creation_date" / 1e6) < DATE '2023-01-01'
GROUP BY
  LPAD(EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("creation_date" / 1e6))::VARCHAR, 2, '0'),
  TO_CHAR(TO_TIMESTAMP_NTZ("creation_date" / 1e6), 'Month')
ORDER BY
  "Month_num";