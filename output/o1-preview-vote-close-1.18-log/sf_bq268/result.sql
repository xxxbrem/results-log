WITH sessions AS (

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160801"

  UNION ALL

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160802"

  UNION ALL

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160803"

  UNION ALL

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160804"

  UNION ALL

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160805"

  UNION ALL

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160806"

  UNION ALL

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160807"

  UNION ALL

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160808"

  UNION ALL

  -- Continue listing each table explicitly without any comments or abbreviations

  -- Replace the following lines with SELECT statements from all tables between GA_SESSIONS_20160809 to GA_SESSIONS_20170731

  -- Example:

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160809"

  UNION ALL

  -- Continue until the last table:

  SELECT "fullVisitorId", "visitStartTime", "device", "totals"
  FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170801"

)

, first_visits AS (
  SELECT "fullVisitorId", MIN("visitStartTime") AS "first_visit_time"
  FROM sessions
  GROUP BY "fullVisitorId"
)

, last_visits AS (
  SELECT s."fullVisitorId", s."visitStartTime" AS "last_visit_time", s."device" AS "last_visit_device"
  FROM sessions s
  JOIN (
    SELECT "fullVisitorId", MAX("visitStartTime") AS "last_visit_time"
    FROM sessions
    GROUP BY "fullVisitorId"
  ) lv ON s."fullVisitorId" = lv."fullVisitorId" AND s."visitStartTime" = lv."last_visit_time"
)

, first_transactions AS (
  SELECT s."fullVisitorId", MIN(s."visitStartTime") AS "first_transaction_time", MIN(s."device") AS "transaction_device"
  FROM sessions s
  WHERE s."totals"::VARIANT:"transactions"::STRING IS NOT NULL
  GROUP BY s."fullVisitorId"
)

, last_event_time AS (
  SELECT 
    fv."fullVisitorId",
    fv."first_visit_time",
    lv."last_visit_time",
    ft."first_transaction_time",
    CASE
      WHEN ft."first_transaction_time" IS NULL OR ft."first_transaction_time" <= lv."last_visit_time" THEN lv."last_visit_time"
      ELSE ft."first_transaction_time"
    END AS "last_event_time",
    CASE
      WHEN ft."first_transaction_time" IS NULL OR ft."first_transaction_time" <= lv."last_visit_time" THEN lv."last_visit_device"
      ELSE ft."transaction_device"
    END AS "event_device"
  FROM first_visits fv
  JOIN last_visits lv 
    ON fv."fullVisitorId" = lv."fullVisitorId"
  LEFT JOIN first_transactions ft 
    ON fv."fullVisitorId" = ft."fullVisitorId"
)

SELECT 
  DATEDIFF('day', TO_TIMESTAMP("first_visit_time"), TO_TIMESTAMP("last_event_time")) AS "Longest_number_of_days",
  "fullVisitorId" AS "user_id"
FROM last_event_time
WHERE "event_device"::VARIANT:"deviceCategory"::STRING = 'mobile'
ORDER BY "Longest_number_of_days" DESC NULLS LAST
LIMIT 1;