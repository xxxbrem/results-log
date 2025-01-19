WITH CustomersWhoBoughtHenley AS (
  SELECT DISTINCT fullVisitorId
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
  WHERE date BETWEEN '20170701' AND '20170731'
    AND hits.eCommerceAction.action_type = '6'
    AND LOWER(product.v2ProductName) = LOWER('YouTube Men\'s Vintage Henley')
)
SELECT product.v2ProductName AS ProductName, SUM(IFNULL(CAST(product.productQuantity AS INT64), 1)) AS TotalPurchases
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
  UNNEST(hits) AS hits,
  UNNEST(hits.product) AS product
WHERE date BETWEEN '20170701' AND '20170731'
  AND hits.eCommerceAction.action_type = '6'
  AND fullVisitorId IN (SELECT fullVisitorId FROM CustomersWhoBoughtHenley)
  AND LOWER(product.v2ProductName) != LOWER('YouTube Men\'s Vintage Henley')
GROUP BY ProductName
ORDER BY TotalPurchases DESC
LIMIT 1