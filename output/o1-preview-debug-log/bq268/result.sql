WITH sessions AS (
  SELECT
    fullVisitorId,
    visitStartTime,
    device.isMobile AS isMobile,
    totals.transactions AS transactions
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
),

user_stats AS (
  SELECT
    fullVisitorId,
    MIN(visitStartTime) AS first_visit_time,
    MAX(visitStartTime) AS last_visit_time,
    MIN(IF(transactions IS NOT NULL AND transactions > 0, visitStartTime, NULL)) AS first_transaction_time
  FROM sessions
  GROUP BY fullVisitorId
),

user_event_times AS (
  SELECT
    fullVisitorId,
    first_visit_time,
    last_visit_time,
    first_transaction_time,
    IF(first_transaction_time IS NOT NULL AND first_transaction_time > last_visit_time, first_transaction_time, last_visit_time) AS last_recorded_event_time
  FROM user_stats
),

last_event_device AS (
  SELECT
    s.fullVisitorId,
    MAX(CAST(s.isMobile AS INT64)) AS isMobile
  FROM sessions AS s
  JOIN user_event_times AS u
    ON s.fullVisitorId = u.fullVisitorId AND s.visitStartTime = u.last_recorded_event_time
  GROUP BY s.fullVisitorId
),

duration_calculation AS (
  SELECT
    u.fullVisitorId,
    u.first_visit_time,
    u.last_recorded_event_time,
    ld.isMobile,
    TIMESTAMP_DIFF(TIMESTAMP_SECONDS(u.last_recorded_event_time), TIMESTAMP_SECONDS(u.first_visit_time), DAY) AS duration_in_days
  FROM user_event_times AS u
  JOIN last_event_device AS ld
    ON u.fullVisitorId = ld.fullVisitorId
  WHERE ld.isMobile = 1
)

SELECT
  MAX(duration_in_days) AS longest_duration_in_days
FROM duration_calculation;