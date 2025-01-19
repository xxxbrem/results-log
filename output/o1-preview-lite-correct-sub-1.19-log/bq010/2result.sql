WITH customers AS (
  SELECT DISTINCT s.fullVisitorId
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*` s,
    UNNEST(s.hits) AS h,
    UNNEST(h.product) AS p
  WHERE
    _TABLE_SUFFIX BETWEEN '20170701' AND '20170731'
    AND p.v2ProductName = 'YouTube Men\'s Vintage Henley'
)

SELECT p.v2ProductName AS ProductName, COUNT(*) AS TotalPurchases
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*` s,
  UNNEST(s.hits) AS h,
  UNNEST(h.product) AS p
WHERE
  _TABLE_SUFFIX BETWEEN '20170701' AND '20170731'
  AND s.fullVisitorId IN (SELECT fullVisitorId FROM customers)
  AND p.v2ProductName IS NOT NULL
  AND p.v2ProductName != 'YouTube Men\'s Vintage Henley'
GROUP BY p.v2ProductName
ORDER BY TotalPurchases DESC
LIMIT 1;