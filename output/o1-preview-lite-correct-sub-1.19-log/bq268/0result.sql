WITH first_visit AS (
  SELECT
    fullVisitorId,
    MIN(TIMESTAMP_SECONDS(visitStartTime)) AS first_visit_time
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  GROUP BY
    fullVisitorId
),
mobile_events AS (
  SELECT
    fullVisitorId,
    TIMESTAMP_SECONDS(visitStartTime) AS event_time
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE
    device.isMobile = TRUE

  UNION ALL

  SELECT
    fullVisitorId,
    TIMESTAMP_MILLIS(visitStartTime * 1000 + CAST(hit.time AS INT64)) AS event_time
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) AS hit
  WHERE
    device.isMobile = TRUE
    AND hit.transaction.transactionId IS NOT NULL
)
,
last_mobile_event AS (
  SELECT
    fullVisitorId,
    MAX(event_time) AS last_event_time
  FROM mobile_events
  GROUP BY
    fullVisitorId
)
SELECT
  MAX(DATE_DIFF(last_event_time, first_visit_time, DAY)) AS longest_number_of_days
FROM
  first_visit
JOIN
  last_mobile_event
USING(fullVisitorId)
;