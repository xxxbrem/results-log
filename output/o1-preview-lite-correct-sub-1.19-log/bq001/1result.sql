WITH all_sessions AS (
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date) AS date,
    device.deviceCategory AS deviceCategory,
    totals.transactions AS transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170201`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170202`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170203`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170204`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170205`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170206`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170207`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170208`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170209`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170210`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170211`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170212`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170213`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170214`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170215`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170216`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170217`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170218`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170219`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170220`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170221`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170222`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170223`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170224`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170225`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170226`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170227`
  
  UNION ALL
  
  SELECT
    fullVisitorId,
    PARSE_DATE('%Y%m%d', date),
    device.deviceCategory,
    totals.transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170228`
),

transaction_sessions AS (
  SELECT
    fullVisitorId,
    date,
    deviceCategory
  FROM all_sessions
  WHERE transactions > 0
),

first_transaction AS (
  SELECT
    fullVisitorId,
    MIN(date) AS first_transaction_date,
    ANY_VALUE(deviceCategory) AS transaction_device
  FROM transaction_sessions
  GROUP BY fullVisitorId
),

first_visits AS (
  SELECT
    fullVisitorId,
    MIN(date) AS first_visit_date
  FROM all_sessions
  GROUP BY fullVisitorId
)

SELECT
  ft.fullVisitorId AS visitor_id,
  DATE_DIFF(ft.first_transaction_date, fv.first_visit_date, DAY) AS days_between_first_transaction_and_first_visit_in_Feb2017,
  ft.transaction_device AS transaction_device
FROM
  first_transaction AS ft
JOIN
  first_visits AS fv
ON
  ft.fullVisitorId = fv.fullVisitorId
ORDER BY
  visitor_id;