WITH
  all_sessions_feb AS (
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170201`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170202`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170203`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170204`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170205`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170206`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170207`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170208`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170209`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170210`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170211`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170212`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170213`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170214`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170215`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170216`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170217`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170218`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170219`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170220`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170221`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170222`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170223`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170224`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170225`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170226`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170227`
    UNION ALL
    SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170228`
  ),
  first_visits AS (
    SELECT
      fullVisitorId,
      MIN(visitStartTime) AS first_visit_time
    FROM all_sessions_feb
    GROUP BY fullVisitorId
  ),
  first_transactions AS (
    SELECT
      fullVisitorId,
      MIN(visitStartTime) AS first_transaction_time
    FROM all_sessions_feb
    WHERE totals.transactions >= 1
    GROUP BY fullVisitorId
  ),
  transaction_device AS (
    SELECT
      fullVisitorId,
      visitStartTime,
      device.deviceCategory AS transaction_device
    FROM all_sessions_feb
    WHERE totals.transactions >= 1
  ),
  first_transactions_with_device AS (
    SELECT
      ft.fullVisitorId,
      ft.first_transaction_time,
      td.transaction_device
    FROM first_transactions ft
    JOIN transaction_device td
    ON ft.fullVisitorId = td.fullVisitorId AND ft.first_transaction_time = td.visitStartTime
  )
SELECT
  ftwd.fullVisitorId AS visitor_id,
  GREATEST(0, DATE_DIFF(DATE(TIMESTAMP_SECONDS(ftwd.first_transaction_time)), DATE(TIMESTAMP_SECONDS(fv.first_visit_time)), DAY)) AS days_between_first_transaction_and_first_visit_in_Feb2017,
  ftwd.transaction_device
FROM first_transactions_with_device ftwd
JOIN first_visits fv
ON ftwd.fullVisitorId = fv.fullVisitorId
ORDER BY visitor_id;