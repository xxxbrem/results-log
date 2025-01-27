WITH cohort_users AS (
  SELECT DISTINCT user_pseudo_id
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE TIMESTAMP_MICROS(user_first_touch_timestamp) BETWEEN TIMESTAMP '2018-09-01 00:00:00+08' AND TIMESTAMP '2018-09-07 23:59:59+08'
),
total_users AS (
  SELECT COUNT(*) AS total_users FROM cohort_users
),
retention AS (
  SELECT 
    1 AS week_number,
    COUNT(DISTINCT user_pseudo_id) AS retained_users
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE user_pseudo_id IN (SELECT user_pseudo_id FROM cohort_users)
    AND TIMESTAMP_MICROS(event_timestamp) BETWEEN TIMESTAMP '2018-09-08 00:00:00+08' AND TIMESTAMP '2018-09-14 23:59:59+08'
  UNION ALL
  SELECT 
    2 AS week_number,
    COUNT(DISTINCT user_pseudo_id) AS retained_users
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE user_pseudo_id IN (SELECT user_pseudo_id FROM cohort_users)
    AND TIMESTAMP_MICROS(event_timestamp) BETWEEN TIMESTAMP '2018-09-15 00:00:00+08' AND TIMESTAMP '2018-09-21 23:59:59+08'
  UNION ALL
  SELECT 
    3 AS week_number,
    COUNT(DISTINCT user_pseudo_id) AS retained_users
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE user_pseudo_id IN (SELECT user_pseudo_id FROM cohort_users)
    AND TIMESTAMP_MICROS(event_timestamp) BETWEEN TIMESTAMP '2018-09-22 00:00:00+08' AND TIMESTAMP '2018-09-28 23:59:59+08'
)
SELECT
  CONCAT('Week ', week_number) AS Week,
  ROUND(retained_users / total_users.total_users * 100, 4) AS Retention_Rate
FROM retention, total_users
ORDER BY week_number;