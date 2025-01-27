SELECT
  first_week AS Week_start_date
FROM (
  SELECT
    first_week,
    COUNT(DISTINCT user_pseudo_id) AS retained_users
  FROM (
    SELECT
      user_pseudo_id,
      DATE_TRUNC(DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)), WEEK(MONDAY)) AS first_week,
      COUNT(DISTINCT DATE_TRUNC(DATE(TIMESTAMP_MICROS(event_timestamp)), WEEK(MONDAY))) AS weeks_active
    FROM `firebase-public-project.analytics_153293282.events_*`
    WHERE user_first_touch_timestamp >= UNIX_MICROS(TIMESTAMP('2018-07-02'))
      AND DATE_TRUNC(DATE(TIMESTAMP_MICROS(event_timestamp)), WEEK(MONDAY)) BETWEEN
          DATE_TRUNC(DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)), WEEK(MONDAY))
          AND DATE_ADD(DATE_TRUNC(DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)), WEEK(MONDAY)), INTERVAL 4 WEEK)
    GROUP BY user_pseudo_id, first_week
  )
  WHERE weeks_active >= 5
  GROUP BY first_week
  ORDER BY retained_users DESC
  LIMIT 1
)