WITH sessions AS (
  SELECT 
    s."fullVisitorId",
    s."visitStartTime",
    s."device",
    s."totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160801" s
  UNION ALL
  SELECT 
    s."fullVisitorId",
    s."visitStartTime",
    s."device",
    s."totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160802" s
  UNION ALL
  SELECT 
    s."fullVisitorId",
    s."visitStartTime",
    s."device",
    s."totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160803" s
  UNION ALL
  -- Continue listing each table explicitly
  SELECT 
    s."fullVisitorId",
    s."visitStartTime",
    s."device",
    s."totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160804" s
  UNION ALL
  -- Repeat for all tables up to GA_SESSIONS_20170801
  -- ...
  SELECT 
    s."fullVisitorId",
    s."visitStartTime",
    s."device",
    s."totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170801" s
),
sessions_data AS (
  SELECT
    s."fullVisitorId",
    s."visitStartTime",
    s."device"::VARIANT:"deviceCategory"::STRING AS "deviceCategory",
    s."totals"::VARIANT:"transactions"::INT AS "transactions"
  FROM sessions s
),
first_visits AS (
  SELECT
    "fullVisitorId",
    MIN("visitStartTime") AS first_visit_time
  FROM sessions_data
  GROUP BY "fullVisitorId"
),
last_visits AS (
  SELECT
    l."fullVisitorId",
    l."visitStartTime" AS last_visit_time,
    l."deviceCategory" AS last_visit_device
  FROM (
    SELECT
      s."fullVisitorId",
      s."visitStartTime",
      s."deviceCategory",
      ROW_NUMBER() OVER (PARTITION BY s."fullVisitorId" ORDER BY s."visitStartTime" DESC NULLS LAST) AS rn
    FROM sessions_data s
  ) l
  WHERE l.rn = 1
),
first_transactions AS (
  SELECT
    f."fullVisitorId",
    f."visitStartTime" AS first_transaction_time,
    f."deviceCategory" AS transaction_device
  FROM (
    SELECT
      s."fullVisitorId",
      s."visitStartTime",
      s."deviceCategory",
      ROW_NUMBER() OVER (PARTITION BY s."fullVisitorId" ORDER BY s."visitStartTime" ASC NULLS LAST) AS rn
    FROM sessions_data s
    WHERE s."transactions" IS NOT NULL
  ) f
  WHERE f.rn = 1
),
user_events AS (
  SELECT
    fv."fullVisitorId",
    TO_TIMESTAMP(fv.first_visit_time) AS first_visit_time,
    CASE
      WHEN ft.first_transaction_time IS NOT NULL THEN TO_TIMESTAMP(ft.first_transaction_time)
      ELSE TO_TIMESTAMP(lv.last_visit_time)
    END AS last_event_time,
    CASE
      WHEN ft.first_transaction_time IS NOT NULL THEN ft.transaction_device
      ELSE lv.last_visit_device
    END AS last_event_device
  FROM first_visits fv
  LEFT JOIN first_transactions ft ON fv."fullVisitorId" = ft."fullVisitorId"
  LEFT JOIN last_visits lv ON fv."fullVisitorId" = lv."fullVisitorId"
),
users_with_mobile_event AS (
  SELECT
    *,
    DATEDIFF('day', first_visit_time, last_event_time) AS days_difference
  FROM user_events
  WHERE last_event_device = 'mobile'
)
SELECT
  MAX(days_difference) AS "Longest_number_of_days"
FROM users_with_mobile_event;