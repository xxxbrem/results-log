SELECT 
  category AS Category,
  COUNT(*) AS Total_articles,
  ROUND(100.0 * SUM(CASE WHEN LOWER(title) LIKE '%education%' OR LOWER(body) LIKE '%education%' THEN 1 ELSE 0 END) / COUNT(*), 4) AS Percentage_mentioning_education
FROM `bigquery-public-data.bbc_news.fulltext`
GROUP BY category;