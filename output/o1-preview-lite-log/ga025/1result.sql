WITH first_open_users AS (
  SELECT DISTINCT user_pseudo_id, user_first_touch_timestamp
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20180901' AND '20180930'
    AND DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)) BETWEEN DATE('2018-09-01') AND DATE('2018-09-30')
),

uninstalls AS (
  SELECT user_pseudo_id, event_timestamp AS uninstall_timestamp
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20180901' AND '20181007'
    AND event_name = 'app_remove'
),

users_uninstalled_within_7_days AS (
  SELECT f.user_pseudo_id, f.user_first_touch_timestamp, u.uninstall_timestamp
  FROM first_open_users f
  INNER JOIN uninstalls u
    ON f.user_pseudo_id = u.user_pseudo_id
  WHERE (u.uninstall_timestamp - f.user_first_touch_timestamp) <= 7 * 24 * 60 * 60 * 1000000
),

crashes AS (
  SELECT DISTINCT user_pseudo_id, event_timestamp
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20180901' AND '20181007'
    AND event_name = 'app_exception'
),

users_with_crash AS (
  SELECT DISTINCT u.user_pseudo_id
  FROM users_uninstalled_within_7_days u
  INNER JOIN crashes c
    ON u.user_pseudo_id = c.user_pseudo_id
  WHERE c.event_timestamp BETWEEN u.user_first_touch_timestamp AND u.uninstall_timestamp
)

SELECT
  ROUND((COUNT(DISTINCT uwc.user_pseudo_id) * 100.0) / COUNT(DISTINCT u.user_pseudo_id), 4) AS Percentage_of_users_who_experienced_app_crash
FROM users_uninstalled_within_7_days u
LEFT JOIN users_with_crash uwc
  ON u.user_pseudo_id = uwc.user_pseudo_id;