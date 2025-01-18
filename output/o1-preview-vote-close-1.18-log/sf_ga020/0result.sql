WITH user_cohort AS (
    SELECT
        "user_pseudo_id",
        MIN(TO_TIMESTAMP_LTZ("event_timestamp"/1e6))::DATE AS "first_touch_date"
    FROM (
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180801
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180802
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180803
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180804
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180805
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180806
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180807
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180808
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180809
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180810
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180811
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180812
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180813
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180814
        UNION ALL
        SELECT "user_pseudo_id", "event_timestamp" FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180815
    ) t
    GROUP BY "user_pseudo_id"
    HAVING MIN(TO_TIMESTAMP_LTZ("event_timestamp"/1e6))::DATE BETWEEN '2018-08-01' AND '2018-08-15'
),
events_data AS (
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180801
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180802
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180803
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180804
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180805
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180806
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180807
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180808
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180809
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180810
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180811
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180812
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180813
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180814
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180815
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180816
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180817
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180818
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180819
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180820
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180821
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180822
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180823
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180824
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180825
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180826
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180827
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180828
    UNION ALL
    SELECT "user_pseudo_id", "event_name", "event_date", "event_timestamp"
    FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180829
),
events_with_cohort AS (
    SELECT
        ed."user_pseudo_id",
        ed."event_name",
        TO_DATE(ed."event_date", 'YYYYMMDD') AS "event_date",
        uc."first_touch_date",
        DATEDIFF('day', uc."first_touch_date", TO_DATE(ed."event_date", 'YYYYMMDD')) AS "days_since_first_touch"
    FROM events_data ed
    JOIN user_cohort uc
    ON ed."user_pseudo_id" = uc."user_pseudo_id"
)
SELECT
    i."event_name" AS "Event_Type",
    ROUND((COUNT(DISTINCT r."user_pseudo_id") / COUNT(DISTINCT i."user_pseudo_id"))::FLOAT, 4) AS "Second_Week_Retention_Rate"
FROM (
    SELECT DISTINCT "user_pseudo_id", "event_name"
    FROM events_with_cohort
    WHERE "event_name" LIKE '%quickplay%' AND "days_since_first_touch" BETWEEN 0 AND 6
) i
LEFT JOIN (
    SELECT DISTINCT "user_pseudo_id", "event_name"
    FROM events_with_cohort
    WHERE "event_name" LIKE '%quickplay%' AND "days_since_first_touch" BETWEEN 7 AND 13
) r
ON i."user_pseudo_id" = r."user_pseudo_id" AND i."event_name" = r."event_name"
GROUP BY i."event_name"
ORDER BY "Second_Week_Retention_Rate" ASC NULLS LAST
LIMIT 1;