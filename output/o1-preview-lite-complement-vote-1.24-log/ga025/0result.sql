WITH first_open_users AS (
  SELECT
    DISTINCT user_pseudo_id,
    TIMESTAMP_MICROS(MIN(user_first_touch_timestamp)) AS first_open_time
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    EXTRACT(MONTH FROM TIMESTAMP_MICROS(user_first_touch_timestamp)) = 9
    AND EXTRACT(YEAR FROM TIMESTAMP_MICROS(user_first_touch_timestamp)) = 2018
  GROUP BY
    user_pseudo_id
),
uninstalled_users AS (
  SELECT
    user_pseudo_id,
    TIMESTAMP_MICROS(MIN(event_timestamp)) AS uninstall_time
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    event_name = 'app_remove'
  GROUP BY
    user_pseudo_id
),
first_seven_days_uninstalls AS (
  SELECT
    f.user_pseudo_id,
    f.first_open_time,
    u.uninstall_time
  FROM
    first_open_users f
  JOIN
    uninstalled_users u
  ON
    f.user_pseudo_id = u.user_pseudo_id
  WHERE
    TIMESTAMP_DIFF(u.uninstall_time, f.first_open_time, DAY) <= 7
),
crash_events AS (
  SELECT
    user_pseudo_id,
    TIMESTAMP_MICROS(event_timestamp) AS crash_time
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    event_name = 'app_exception'
),
users_with_crashes AS (
  SELECT
    DISTINCT f.user_pseudo_id
  FROM
    first_seven_days_uninstalls f
  JOIN
    crash_events c
  ON
    f.user_pseudo_id = c.user_pseudo_id
  WHERE
    c.crash_time BETWEEN f.first_open_time AND f.uninstall_time
    OR c.crash_time BETWEEN f.first_open_time AND TIMESTAMP_ADD(f.first_open_time, INTERVAL 7 DAY)
),
totals AS (
  SELECT
    COUNT(DISTINCT user_pseudo_id) AS total_users
  FROM
    first_seven_days_uninstalls
),
crashed AS (
  SELECT
    COUNT(DISTINCT user_pseudo_id) AS crashed_users
  FROM
    users_with_crashes
)
SELECT
  ROUND((crashed.crashed_users / totals.total_users) * 100, 4) AS Percentage_of_users_who_experienced_app_crash
FROM
  totals,
  crashed;