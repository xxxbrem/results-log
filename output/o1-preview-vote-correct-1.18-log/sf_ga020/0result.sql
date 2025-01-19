WITH
all_events AS (
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180801
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180802
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180803
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180804
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180805
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180806
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180807
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180808
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180809
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180810
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180811
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180812
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180813
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180814
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180815
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180816
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180817
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180818
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180819
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180820
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180821
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180822
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180823
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180824
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180825
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180826
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180827
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180828
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180829
),
user_first_engagement AS (
    SELECT "user_pseudo_id", MIN("event_date") AS first_engagement_date
    FROM all_events
    GROUP BY "user_pseudo_id"
    HAVING MIN("event_date") BETWEEN '20180801' AND '20180815'
),
user_quickplay_first_events AS (
    SELECT DISTINCT ae."user_pseudo_id", ae."event_name"
    FROM all_events ae
    JOIN user_first_engagement ufe ON ae."user_pseudo_id" = ufe."user_pseudo_id"
    WHERE ae."event_date" = ufe.first_engagement_date
      AND ae."event_name" LIKE '%quickplay%'
),
user_second_week_activity AS (
    SELECT DISTINCT ae."user_pseudo_id"
    FROM all_events ae
    JOIN user_first_engagement ufe ON ae."user_pseudo_id" = ufe."user_pseudo_id"
    WHERE DATEDIFF('day', TO_DATE(ufe.first_engagement_date, 'YYYYMMDD'), TO_DATE(ae."event_date", 'YYYYMMDD')) BETWEEN 7 AND 13
)
SELECT qfe."event_name" AS quickplay_event_type,
       ROUND(
           (COUNT(DISTINCT CASE WHEN usa."user_pseudo_id" IS NOT NULL THEN qfe."user_pseudo_id" END) * 100.0) 
           / NULLIF(COUNT(DISTINCT qfe."user_pseudo_id"), 0), 4
       ) AS second_week_retention_rate
FROM user_quickplay_first_events qfe
LEFT JOIN user_second_week_activity usa ON qfe."user_pseudo_id" = usa."user_pseudo_id"
GROUP BY qfe."event_name"
ORDER BY second_week_retention_rate ASC
LIMIT 1;