WITH user_cohorts AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(MIN(user_first_touch_timestamp))), WEEK(MONDAY)) AS cohort_week
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180709' AND '20180917'
  GROUP BY user_pseudo_id
  HAVING MIN(DATE(TIMESTAMP_MICROS(user_first_touch_timestamp))) >= DATE('2018-07-09')
),
events AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(event_timestamp)), WEEK(MONDAY)) AS event_week
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180709' AND '20181002'
),
user_activity AS (
  SELECT
    uc.user_pseudo_id,
    uc.cohort_week,
    e.event_week,
    DATE_DIFF(e.event_week, uc.cohort_week, WEEK(MONDAY)) AS week_number
  FROM user_cohorts uc
  JOIN events e ON uc.user_pseudo_id = e.user_pseudo_id
  WHERE DATE_DIFF(e.event_week, uc.cohort_week, WEEK(MONDAY)) IN (1, 2)
),
retention AS (
  SELECT
    uc.cohort_week,
    COUNT(DISTINCT uc.user_pseudo_id) AS users_in_cohort,
    COUNT(DISTINCT IF(ua.week_number = 1, ua.user_pseudo_id, NULL)) AS retained_week1,
    COUNT(DISTINCT IF(ua.week_number = 2, ua.user_pseudo_id, NULL)) AS retained_week2
  FROM user_cohorts uc
  LEFT JOIN user_activity ua ON uc.user_pseudo_id = ua.user_pseudo_id AND uc.cohort_week = ua.cohort_week
  GROUP BY uc.cohort_week
)
SELECT
  FORMAT_DATE('%Y-%m-%d', r.cohort_week) AS Cohort_Week_Start,
  r.users_in_cohort AS Users_in_Cohort,
  ROUND((COALESCE(r.retained_week1, 0) / r.users_in_cohort) * 100, 4) AS Retention_Week1_Pct,
  ROUND((COALESCE(r.retained_week2, 0) / r.users_in_cohort) * 100, 4) AS Retention_Week2_Pct
FROM retention r
ORDER BY r.cohort_week;