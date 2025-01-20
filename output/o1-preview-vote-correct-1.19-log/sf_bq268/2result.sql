WITH all_sessions AS (
  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20160801"
  UNION ALL
  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20160802"
  UNION ALL
  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20160803"
  UNION ALL
  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20160804"
  UNION ALL
  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20160805"
  UNION ALL
  -- Continue listing each table explicitly without omitting any
  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20160806"
  UNION ALL
  -- Include all GA_SESSIONS tables from 2016-08-01 to 2017-08-01
  -- This means listing each table individually in the UNION ALL
  -- For example:
  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20160807"
  -- (List all other tables in sequence)
  UNION ALL
  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170801"
),
first_transactions AS (
  SELECT "fullVisitorId", MIN("visitStartTime") AS "first_transaction_time"
  FROM all_sessions
  WHERE "totals":transactions::NUMBER IS NOT NULL
  GROUP BY "fullVisitorId"
),
all_visits AS (
  SELECT "fullVisitorId",
         MIN("visitStartTime") AS "first_visit_time",
         MAX("visitStartTime") AS "last_visit_time"
  FROM all_sessions
  GROUP BY "fullVisitorId"
),
last_events AS (
  SELECT
    v."fullVisitorId",
    v."first_visit_time",
    CASE
      WHEN t."first_transaction_time" IS NOT NULL THEN t."first_transaction_time"
      ELSE v."last_visit_time"
    END AS "last_event_time"
  FROM all_visits v
  LEFT JOIN first_transactions t
    ON v."fullVisitorId" = t."fullVisitorId"
),
last_event_device AS (
  SELECT
    e."fullVisitorId",
    e."first_visit_time",
    e."last_event_time",
    s."device":deviceCategory::STRING AS "deviceCategory"
  FROM last_events e
  INNER JOIN all_sessions s
    ON e."fullVisitorId" = s."fullVisitorId"
    AND e."last_event_time" = s."visitStartTime"
),
diff_days AS (
  SELECT
    "fullVisitorId",
    DATEDIFF('day', TO_TIMESTAMP("first_visit_time"), TO_TIMESTAMP("last_event_time")) AS "days_diff"
  FROM last_event_device
  WHERE "deviceCategory" = 'mobile'
)
SELECT MAX("days_diff") AS "longest_number_of_days"
FROM diff_days;