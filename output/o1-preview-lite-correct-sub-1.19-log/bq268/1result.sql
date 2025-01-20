WITH first_visits AS (
  SELECT
    fullVisitorId,
    MIN(PARSE_DATE('%Y%m%d', date)) AS first_visit_date
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  GROUP BY
    fullVisitorId
),
transactions_on_mobile AS (
  SELECT
    t.fullVisitorId,
    MAX(PARSE_DATE('%Y%m%d', t.date)) AS transaction_date
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*` AS t,
    UNNEST(t.hits) AS h
  WHERE
    h.transaction.transactionId IS NOT NULL
    AND t.device.isMobile = TRUE
  GROUP BY
    t.fullVisitorId
),
sessions_on_mobile AS (
  SELECT
    fullVisitorId,
    MAX(PARSE_DATE('%Y%m%d', date)) AS session_date
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  WHERE
    device.isMobile = TRUE
  GROUP BY
    fullVisitorId
),
last_events AS (
  SELECT
    fullVisitorId,
    GREATEST(
      IFNULL(MAX(transaction_date), DATE '1900-01-01'),
      IFNULL(MAX(session_date), DATE '1900-01-01')
    ) AS last_event_date
  FROM (
    SELECT
      fullVisitorId,
      transaction_date,
      NULL AS session_date
    FROM
      transactions_on_mobile
    UNION ALL
    SELECT
      fullVisitorId,
      NULL AS transaction_date,
      session_date
    FROM
      sessions_on_mobile
  )
  GROUP BY
    fullVisitorId
)
SELECT
  MAX(DATE_DIFF(last_event_date, first_visit_date, DAY)) AS longest_number_of_days
FROM
  first_visits
JOIN
  last_events
USING(fullVisitorId);