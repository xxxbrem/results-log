WITH all_events AS (
    -- Include events from August 1 to August 29 to cover first engagement dates and second-week events
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180801"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180802"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180803"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180804"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180805"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180806"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180807"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180808"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180809"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180810"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180811"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180812"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180813"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180814"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180815"
    UNION ALL
    -- Include events up to August 29 to cover the second week after August 15
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180816"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180817"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180818"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180819"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180820"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180821"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180822"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180823"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180824"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180825"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180826"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180827"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180828"
    UNION ALL
    SELECT "user_pseudo_id", "user_first_touch_timestamp", "event_name", "event_params", "event_timestamp"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180829"
),
user_first_engagements AS (
    SELECT "user_pseudo_id", 
           DATE_TRUNC('DAY', TO_TIMESTAMP_NTZ(MIN("user_first_touch_timestamp") / 1000000)) AS "first_engagement_date"
    FROM all_events
    GROUP BY "user_pseudo_id"
    HAVING DATE_TRUNC('DAY', TO_TIMESTAMP_NTZ(MIN("user_first_touch_timestamp") / 1000000)) BETWEEN '2018-08-01' AND '2018-08-15'
),
initial_quickplay_events AS (
    SELECT DISTINCT t."user_pseudo_id", 
           f.value:"value":"string_value"::STRING AS "quickplay_event_type",
           u."first_engagement_date"
    FROM all_events t
    INNER JOIN user_first_engagements u ON t."user_pseudo_id" = u."user_pseudo_id"
    , LATERAL FLATTEN(input => t."event_params") f
    WHERE t."event_name" LIKE '%quickplay%'
      AND f.value:"key"::STRING = 'board'
      AND DATE_TRUNC('DAY', TO_TIMESTAMP_NTZ(t."event_timestamp" / 1000000)) = u."first_engagement_date"
),
users_by_event_type AS (
    SELECT "quickplay_event_type", "user_pseudo_id", "first_engagement_date"
    FROM initial_quickplay_events
),
second_week_engagements AS (
    SELECT DISTINCT t."user_pseudo_id", u."quickplay_event_type"
    FROM all_events t
    INNER JOIN users_by_event_type u ON t."user_pseudo_id" = u."user_pseudo_id"
    , LATERAL FLATTEN(input => t."event_params") f
    WHERE DATEDIFF('DAY', u."first_engagement_date", DATE_TRUNC('DAY', TO_TIMESTAMP_NTZ(t."event_timestamp" / 1000000))) BETWEEN 8 AND 14
      AND t."event_name" LIKE '%quickplay%'
      AND f.value:"key"::STRING = 'board'
      AND f.value:"value":"string_value"::STRING = u."quickplay_event_type"
),
retention_by_event_type AS (
    SELECT 
        e."quickplay_event_type",
        COUNT(DISTINCT e."user_pseudo_id") AS initial_users,
        COUNT(DISTINCT s."user_pseudo_id") AS retained_users,
        ROUND(COALESCE((COUNT(DISTINCT s."user_pseudo_id")::FLOAT / NULLIF(COUNT(DISTINCT e."user_pseudo_id"), 0)), 0), 4) AS "second_week_retention_rate"
    FROM users_by_event_type e
    LEFT JOIN second_week_engagements s ON e."user_pseudo_id" = s."user_pseudo_id" AND e."quickplay_event_type" = s."quickplay_event_type"
    GROUP BY e."quickplay_event_type"
),
lowest_retention AS (
    SELECT 
        "quickplay_event_type",
        "second_week_retention_rate"
    FROM retention_by_event_type
    ORDER BY "second_week_retention_rate" ASC NULLS LAST
    LIMIT 1
)
SELECT "quickplay_event_type", "second_week_retention_rate"
FROM lowest_retention;