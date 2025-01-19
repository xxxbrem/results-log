SELECT
  "category" AS Category,
  COUNT(*) AS Total_articles,
  ROUND(
    100.0 * SUM(CASE WHEN "body" ILIKE '%education%' OR "title" ILIKE '%education%' THEN 1 ELSE 0 END) / COUNT(*),
    4
  ) AS Percentage_mentioning_education
FROM
  "BBC"."BBC_NEWS"."FULLTEXT"
GROUP BY
  "category"
ORDER BY
  Percentage_mentioning_education DESC NULLS LAST, Category
;