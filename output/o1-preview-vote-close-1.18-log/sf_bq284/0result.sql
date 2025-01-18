SELECT
  "category" AS "Category",
  COUNT(*) AS "Number_of_Articles",
  ROUND(
    COUNT(CASE WHEN "body" ILIKE '%education%' OR "title" ILIKE '%education%' THEN 1 END) * 100.0 / COUNT(*), 
    4
  ) AS "Percentage_Mentioning_Education"
FROM BBC.BBC_NEWS.FULLTEXT
GROUP BY "category";