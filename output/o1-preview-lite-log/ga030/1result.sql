SELECT cohort_week AS Week_start_date
FROM (
  SELECT 
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(`user_first_touch_timestamp`)), WEEK(MONDAY)) AS cohort_week,
    COUNT(DISTINCT `user_pseudo_id`) AS retained_user_count
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE DATE(TIMESTAMP_MICROS(`user_first_touch_timestamp`)) >= '2018-07-02'
    AND DATE(TIMESTAMP_MICROS(`event_timestamp`)) BETWEEN DATE(TIMESTAMP_MICROS(`user_first_touch_timestamp`))
    AND DATE_ADD(DATE(TIMESTAMP_MICROS(`user_first_touch_timestamp`)), INTERVAL 28 DAY)
  GROUP BY cohort_week
)
ORDER BY retained_user_count DESC
LIMIT 1;