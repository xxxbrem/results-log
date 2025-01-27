WITH cohort_users AS (
    SELECT DISTINCT user_pseudo_id
    FROM `firebase-public-project.analytics_153293282.events_*`
    WHERE DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)) BETWEEN '2018-07-02' AND '2018-07-08'
),
cohort_size AS (
    SELECT COUNT(*) AS total_new_users FROM cohort_users
),
user_events AS (
    SELECT
        user_pseudo_id,
        DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date
    FROM `firebase-public-project.analytics_153293282.events_*`
    WHERE
        DATE(TIMESTAMP_MICROS(event_timestamp)) BETWEEN '2018-07-02' AND '2018-08-05'
        AND user_pseudo_id IN (SELECT user_pseudo_id FROM cohort_users)
),
user_weeks AS (
    SELECT
        DISTINCT user_pseudo_id,
        CASE
            WHEN event_date BETWEEN '2018-07-02' AND '2018-07-08' THEN 0
            WHEN event_date BETWEEN '2018-07-09' AND '2018-07-15' THEN 1
            WHEN event_date BETWEEN '2018-07-16' AND '2018-07-22' THEN 2
            WHEN event_date BETWEEN '2018-07-23' AND '2018-07-29' THEN 3
            WHEN event_date BETWEEN '2018-07-30' AND '2018-08-05' THEN 4
        END AS week_number
    FROM user_events
),
week_numbers AS (
    SELECT 0 AS week_number UNION ALL
    SELECT 1 UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4
),
retention_counts AS (
    SELECT
        wn.week_number,
        COUNT(DISTINCT uw.user_pseudo_id) AS Number_of_Retained_Users
    FROM
        week_numbers wn
    LEFT JOIN
        user_weeks uw
    ON
        wn.week_number = uw.week_number
    GROUP BY
        wn.week_number
)
SELECT
    CONCAT('Week', CAST(week_number AS STRING)) AS Week,
    (SELECT total_new_users FROM cohort_size) AS Total_New_Users,
    Number_of_Retained_Users
FROM
    retention_counts
ORDER BY
    week_number;