WITH transactions AS (
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date) AS date,
    visitStartTime,
    device.deviceCategory AS device_used_in_transaction
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201702*`,
    UNNEST(hits) AS hit
  WHERE hit.transaction.transactionId IS NOT NULL
),

first_transaction AS (
  SELECT
    fullVisitorId,
    MIN(date) AS first_transaction_date,
    ARRAY_AGG(device_used_in_transaction ORDER BY date, visitStartTime LIMIT 1)[OFFSET(0)] AS device_used_in_transaction
  FROM transactions
  GROUP BY fullVisitorId
),

first_visit AS (
  SELECT
    fullVisitorId,
    MIN(PARSE_DATE('%Y%m%d', date)) AS first_visit_date
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201702*`
  GROUP BY fullVisitorId
)

SELECT
  t.fullVisitorId,
  DATE_DIFF(t.first_transaction_date, v.first_visit_date, DAY) AS days_between_first_transaction_and_first_visit,
  t.device_used_in_transaction
FROM first_transaction t
JOIN first_visit v
ON t.fullVisitorId = v.fullVisitorId
ORDER BY t.fullVisitorId;