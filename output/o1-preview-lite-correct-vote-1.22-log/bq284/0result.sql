SELECT
  `category` AS Category,
  COUNT(*) AS Total_Articles,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(LOWER(`body`) LIKE '%education%'),
      COUNT(*)
    ) * 100,
    4
  ) AS Percentage_Mentioning_Education
FROM
  `bigquery-public-data.bbc_news.fulltext`
GROUP BY
  `category`