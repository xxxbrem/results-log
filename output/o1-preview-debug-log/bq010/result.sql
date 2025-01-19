SELECT product.v2ProductName, SUM(product.productQuantity) AS TotalQuantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*` AS session,
UNNEST(session.hits) AS hits,
UNNEST(hits.product) AS product
WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170731'
  AND hits.transaction.transactionId IN (
    SELECT DISTINCT hits.transaction.transactionId
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS prod
    WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170731'
      AND LOWER(prod.v2ProductName) LIKE LOWER('%youtube men%s vintage henley%')
      AND hits.eCommerceAction.action_type = '6'
      AND hits.transaction.transactionId IS NOT NULL
  )
  AND LOWER(product.v2ProductName) NOT LIKE LOWER('%youtube men%s vintage henley%')
  AND hits.eCommerceAction.action_type = '6'
GROUP BY product.v2ProductName
ORDER BY TotalQuantity DESC
LIMIT 1;