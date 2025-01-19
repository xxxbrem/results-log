WITH months AS (
  SELECT 1 AS Month_num UNION ALL
  SELECT 2 UNION ALL
  SELECT 3 UNION ALL
  SELECT 4 UNION ALL
  SELECT 5 UNION ALL
  SELECT 6 UNION ALL
  SELECT 7 UNION ALL
  SELECT 8 UNION ALL
  SELECT 9 UNION ALL
  SELECT 10 UNION ALL
  SELECT 11 UNION ALL
  SELECT 12
),
questions AS (
  SELECT
    EXTRACT(month FROM TO_TIMESTAMP_NTZ("creation_date" / 1000000)) AS Month_num,
    "tags"
  FROM
    STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
  WHERE
    TO_TIMESTAMP_NTZ("creation_date" / 1000000) >= '2022-01-01'::date
    AND TO_TIMESTAMP_NTZ("creation_date" / 1000000) < '2023-01-01'::date
),
monthly_counts AS (
  SELECT
    Month_num,
    COUNT(*) AS total_questions,
    SUM(CASE WHEN '|' || "tags" || '|' LIKE '%|python|%' THEN 1 ELSE 0 END) AS python_questions
  FROM
    questions
  GROUP BY
    Month_num
)
SELECT
  m.Month_num,
  TO_CHAR(DATE_FROM_PARTS(2022, m.Month_num, 1), 'Mon') AS Month,
  ROUND(COALESCE(python_questions / total_questions, 0), 4) AS Proportion
FROM
  months m
LEFT JOIN
  monthly_counts mc
ON
  m.Month_num = mc.Month_num
ORDER BY
  m.Month_num;