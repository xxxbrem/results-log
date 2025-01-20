SELECT
  `category` AS Category,
  COUNT(*) AS Total_Articles,
  ROUND(SUM(CASE WHEN LOWER(`body`) LIKE '%education%' THEN 1 ELSE 0 END) / COUNT(*) * 100, 4) AS Percentage
FROM `bigquery-public-data.bbc_news.fulltext`
GROUP BY `category`
ORDER BY `category`;