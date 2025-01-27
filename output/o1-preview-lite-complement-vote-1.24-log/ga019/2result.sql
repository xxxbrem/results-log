WITH users_installed AS (
  SELECT DISTINCT user_pseudo_id
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20180801' AND '20180930'
    AND event_name = 'first_open'
),
user_active_days AS (
  SELECT
    user_pseudo_id,
    DATE_DIFF(
      TIMESTAMP_MICROS(MAX(event_timestamp)),
      TIMESTAMP_MICROS(MIN(event_timestamp)),
      DAY
    ) AS days_active
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE user_pseudo_id IN (SELECT user_pseudo_id FROM users_installed)
  GROUP BY user_pseudo_id
),
users_did_not_uninstall_within_7_days AS (
  SELECT
    user_pseudo_id
  FROM user_active_days
  WHERE days_active > 7
)
SELECT
  ROUND((COUNT(*) / (SELECT COUNT(*) FROM users_installed)) * 100, 4) AS percentage_of_users_did_not_uninstall_within_7_days
FROM users_did_not_uninstall_within_7_days;