WITH cohorts AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)), WEEK(MONDAY)) AS cohort_week_start
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180709' AND '20181002'
    AND DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)) >= DATE('2018-07-09')
  GROUP BY
    user_pseudo_id,
    cohort_week_start
),

events_per_user_week AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(event_timestamp)), WEEK(MONDAY)) AS event_week_start
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180709' AND '20181002'
  GROUP BY
    user_pseudo_id,
    event_week_start
),

retention AS (
  SELECT
    c.cohort_week_start,
    COUNT(DISTINCT c.user_pseudo_id) AS users_in_cohort,
    COUNT(DISTINCT CASE WHEN e.event_week_start = DATE_ADD(c.cohort_week_start, INTERVAL 1 WEEK) THEN c.user_pseudo_id END) AS users_retained_week1,
    COUNT(DISTINCT CASE WHEN e.event_week_start = DATE_ADD(c.cohort_week_start, INTERVAL 2 WEEK) THEN c.user_pseudo_id END) AS users_retained_week2
  FROM
    cohorts c
  LEFT JOIN
    events_per_user_week e
  ON
    c.user_pseudo_id = e.user_pseudo_id
    AND e.event_week_start IN (
      DATE_ADD(c.cohort_week_start, INTERVAL 1 WEEK),
      DATE_ADD(c.cohort_week_start, INTERVAL 2 WEEK)
    )
  GROUP BY
    c.cohort_week_start
)

SELECT
  FORMAT_DATE('%Y-%m-%d', cohort_week_start) AS Cohort_Week_Start,
  users_in_cohort AS Users_in_Cohort,
  ROUND(IFNULL(users_retained_week1 / users_in_cohort * 100, 4), 4) AS Retention_Week1_Percentage,
  ROUND(IFNULL(users_retained_week2 / users_in_cohort * 100, 4), 4) AS Retention_Week2_Percentage
FROM
  retention
ORDER BY
  cohort_week_start;