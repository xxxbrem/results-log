WITH july_data AS (
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170701`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170702`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170703`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170704`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170705`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170706`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170707`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170708`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170709`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170710`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170711`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170712`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170713`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170714`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170715`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170716`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170717`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170718`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170719`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170720`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170721`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170722`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170723`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170724`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170725`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170726`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170727`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170728`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170729`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170730`
  UNION ALL
  SELECT *
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170731`
),
customers AS (
  SELECT DISTINCT t.fullVisitorId
  FROM july_data AS t,
    UNNEST(t.hits) AS hit,
    UNNEST(hit.product) AS product
  WHERE product.v2ProductName = 'YouTube Men\'s Vintage Henley'
)
SELECT sub.ProductName, SUM(sub.productQuantity) AS TotalPurchases
FROM (
  SELECT t.fullVisitorId, product.v2ProductName AS ProductName, product.productQuantity
  FROM july_data AS t,
    UNNEST(t.hits) AS hit,
    UNNEST(hit.product) AS product
  WHERE t.fullVisitorId IN (SELECT fullVisitorId FROM customers)
    AND product.v2ProductName != 'YouTube Men\'s Vintage Henley'
) AS sub
GROUP BY sub.ProductName
ORDER BY TotalPurchases DESC
LIMIT 1;