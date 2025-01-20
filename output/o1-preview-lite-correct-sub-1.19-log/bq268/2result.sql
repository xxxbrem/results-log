WITH sessions AS (
  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions AS transactions,
    device.isMobile AS isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160801`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160802`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160803`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160804`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160805`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160806`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160807`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160808`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160809`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160810`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160811`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160812`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160813`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160814`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160815`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160816`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160817`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160818`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160819`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160820`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160821`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160822`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160823`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160824`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160825`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160826`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160827`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160828`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160829`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160830`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20160831`

  UNION ALL

  -- Repeat the above pattern for all dates from 2016-09-01 to 2017-08-01

  -- Example for the last few tables:

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170729`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170730`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170731`

  UNION ALL

  SELECT
    fullVisitorId,
    visitStartTime,
    totals.transactions,
    device.isMobile
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
),

flt AS (
  SELECT
    fullVisitorId,
    MIN(visitStartTime) AS first_visit,
    MAX(visitStartTime) AS last_visit,
    MIN(IF(transactions > 0, visitStartTime, NULL)) AS first_transaction
  FROM sessions
  GROUP BY fullVisitorId
),

last_visit_info AS (
  SELECT
    s.fullVisitorId,
    s.isMobile AS last_visit_isMobile
  FROM sessions AS s
  INNER JOIN flt ON s.fullVisitorId = flt.fullVisitorId AND s.visitStartTime = flt.last_visit
),

first_transaction_info AS (
  SELECT
    s.fullVisitorId,
    s.isMobile AS first_transaction_isMobile
  FROM sessions AS s
  INNER JOIN flt ON s.fullVisitorId = flt.fullVisitorId AND s.visitStartTime = flt.first_transaction
)

SELECT
  MAX(DATE_DIFF(
    DATE(TIMESTAMP_SECONDS(
      CASE
        WHEN flt.first_transaction IS NOT NULL THEN flt.first_transaction
        ELSE flt.last_visit
      END)),
    DATE(TIMESTAMP_SECONDS(flt.first_visit)),
    DAY)) AS longest_number_of_days
FROM flt
LEFT JOIN last_visit_info
  ON flt.fullVisitorId = last_visit_info.fullVisitorId
LEFT JOIN first_transaction_info
  ON flt.fullVisitorId = first_transaction_info.fullVisitorId
WHERE
  (flt.first_transaction IS NOT NULL AND first_transaction_info.first_transaction_isMobile = TRUE)
  OR
  (flt.first_transaction IS NULL AND last_visit_info.last_visit_isMobile = TRUE)