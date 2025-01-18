WITH sessions AS (
    SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160801"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160802"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160803"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160804"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160805"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160806"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160807"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160808"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160809"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160810"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160811"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160812"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160813"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160814"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160815"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160816"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160817"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160818"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160819"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160820"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160821"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160822"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160823"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160824"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160825"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160826"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160827"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160828"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160829"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160830"
    UNION ALL SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160831"
    UNION ALL
    SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160901"
    UNION ALL
    -- Include all other GA_SESSIONS_YYYYMMDD tables up to GA_SESSIONS_20170801 --
    SELECT "fullVisitorId", "visitStartTime", "device", "totals" FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170801"
),
user_visits AS (
    SELECT
        "fullVisitorId",
        MIN("visitStartTime") AS first_visit_time,
        MAX("visitStartTime") AS last_visit_time,
        MIN(CASE WHEN "totals"::VARIANT:"transactions"::NUMBER > 0 THEN "visitStartTime" END) AS first_transaction_time
        FROM sessions
        GROUP BY "fullVisitorId"
),
last_event_times AS (
    SELECT
        "fullVisitorId",
        first_visit_time,
        last_visit_time,
        first_transaction_time,
        CASE
            WHEN first_transaction_time IS NOT NULL THEN first_transaction_time
            ELSE last_visit_time
        END AS last_event_time
    FROM user_visits
),
last_event_sessions AS (
    SELECT s."fullVisitorId", s."visitStartTime", s."device"
    FROM sessions s
    JOIN last_event_times l ON s."fullVisitorId" = l."fullVisitorId" AND s."visitStartTime" = l.last_event_time
),
mobile_last_events AS (
    SELECT 
        l."fullVisitorId",
        l.first_visit_time,
        l.last_event_time,
        s."device"::VARIANT:"deviceCategory"::STRING AS deviceCategory
    FROM last_event_times l
    JOIN last_event_sessions s ON l."fullVisitorId" = s."fullVisitorId" AND l.last_event_time = s."visitStartTime"
    WHERE s."device"::VARIANT:"deviceCategory"::STRING = 'mobile'
),
durations AS (
    SELECT
        "fullVisitorId" AS UserId,
        DATEDIFF('day', TO_TIMESTAMP(first_visit_time), TO_TIMESTAMP(last_event_time)) AS LongestDurationDays
    FROM mobile_last_events
),
max_duration_user AS (
    SELECT
        UserId,
        LongestDurationDays
    FROM durations
    ORDER BY LongestDurationDays DESC NULLS LAST
    LIMIT 1
)
SELECT
    UserId,
    LongestDurationDays
FROM max_duration_user;