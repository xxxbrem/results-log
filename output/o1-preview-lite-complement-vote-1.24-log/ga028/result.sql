WITH new_users AS (
  SELECT
    DISTINCT `user_pseudo_id`
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180702' AND '20180708'
    AND DATE(TIMESTAMP_MICROS(`user_first_touch_timestamp`)) BETWEEN '2018-07-02' AND '2018-07-08'
),
user_events AS (
  SELECT
    `user_pseudo_id`,
    CASE
      WHEN `event_date` BETWEEN '20180702' AND '20180708' THEN 'Week0'
      WHEN `event_date` BETWEEN '20180709' AND '20180715' THEN 'Week1'
      WHEN `event_date` BETWEEN '20180716' AND '20180722' THEN 'Week2'
      WHEN `event_date` BETWEEN '20180723' AND '20180729' THEN 'Week3'
      WHEN `event_date` BETWEEN '20180730' AND '20180805' THEN 'Week4'
      ELSE NULL
    END AS `Week`
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180702' AND '20180805'
    AND `user_pseudo_id` IN (SELECT `user_pseudo_id` FROM new_users)
),
retention AS (
  SELECT
    `Week`,
    COUNT(DISTINCT `user_pseudo_id`) AS `Number_of_Retained_Users`
  FROM
    user_events
  WHERE
    `Week` IS NOT NULL
  GROUP BY
    `Week`
),
total_new_users AS (
  SELECT COUNT(*) AS `Total_New_Users` FROM new_users
)
SELECT
  r.`Week`,
  t.`Total_New_Users`,
  r.`Number_of_Retained_Users`
FROM
  retention r CROSS JOIN total_new_users t
ORDER BY
  r.`Week`;