SELECT
  LPAD(EXTRACT(month FROM month_start)::VARCHAR, 2, '0') AS "Month_num",
  TO_CHAR(month_start, 'Mon') AS "Month",
  ROUND(python_questions::FLOAT / total_questions, 4) AS "Proportion_of_Python_Questions"
FROM (
  SELECT
    DATE_TRUNC('month', TO_TIMESTAMP_NTZ("creation_date" / 1000000)) AS month_start,
    COUNT(*) AS total_questions,
    SUM(CASE WHEN "tags" ILIKE '%python%' THEN 1 ELSE 0 END) AS python_questions
  FROM
    STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
  WHERE
    TO_TIMESTAMP_NTZ("creation_date" / 1000000) >= '2022-01-01'
    AND TO_TIMESTAMP_NTZ("creation_date" / 1000000) < '2023-01-01'
  GROUP BY
    month_start
)
ORDER BY
  "Month_num";