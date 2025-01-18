WITH all_events AS (
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180801"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180802"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180803"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180804"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180805"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180806"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180807"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180808"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180809"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180810"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180811"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180812"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180813"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180814"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180815"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180816"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180817"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180818"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180819"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180820"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180821"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180822"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180823"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180824"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180825"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180826"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180827"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180828"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180829"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180830"
    UNION ALL
    SELECT "event_timestamp", "event_name", "user_pseudo_id", "user_first_touch_timestamp"
    FROM FIREBASE.ANALYTICS_153293282."EVENTS_20180831"
),
user_first_engagement AS (
    SELECT DISTINCT e."user_pseudo_id",
         (e."user_first_touch_timestamp" / 1000000)::TIMESTAMP AS first_touch_time
    FROM all_events e
    WHERE DATE((e."user_first_touch_timestamp" / 1000000)::TIMESTAMP) BETWEEN '2018-08-01' AND '2018-08-15'
),
initial_engagement_events AS (
    SELECT e."user_pseudo_id", e."event_name", u.first_touch_time
    FROM all_events e
    JOIN user_first_engagement u ON e."user_pseudo_id" = u."user_pseudo_id"
    WHERE DATE((e."event_timestamp" / 1000000)::TIMESTAMP) = DATE(u.first_touch_time)
      AND e."event_name" LIKE '%quickplay%'
),
user_event_counts AS (
    SELECT "event_name", COUNT(DISTINCT "user_pseudo_id") AS initial_user_count
    FROM initial_engagement_events
    GROUP BY "event_name"
),
retention_events AS (
    SELECT DISTINCT e."user_pseudo_id"
    FROM all_events e
    JOIN user_first_engagement u ON e."user_pseudo_id" = u."user_pseudo_id"
    WHERE ((e."event_timestamp" / 1000000)::TIMESTAMP) >= (u.first_touch_time + INTERVAL '7 DAY')
      AND ((e."event_timestamp" / 1000000)::TIMESTAMP) < (u.first_touch_time + INTERVAL '14 DAY')
),
user_retained AS (
    SELECT ie."event_name", COUNT(DISTINCT ie."user_pseudo_id") AS retained_user_count
    FROM initial_engagement_events ie
    JOIN retention_events re ON ie."user_pseudo_id" = re."user_pseudo_id"
    GROUP BY ie."event_name"
)
SELECT uec."event_name" AS event_type,
       ROUND((COALESCE(ur.retained_user_count, 0)::FLOAT / uec.initial_user_count), 4) AS second_week_retention_rate
FROM user_event_counts uec
LEFT JOIN user_retained ur ON uec."event_name" = ur."event_name"
ORDER BY second_week_retention_rate ASC NULLS LAST
LIMIT 1;