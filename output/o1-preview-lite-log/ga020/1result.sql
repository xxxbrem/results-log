SELECT
  t1.event_name AS Event_Type,
  ROUND((COALESCE(t2.returning_users, 0) / t1.total_users) * 100, 4) AS Second_Week_Retention_Rate
FROM (
  SELECT `event_name`, COUNT(DISTINCT `user_pseudo_id`) AS total_users
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20180801' AND '20180815'
    AND `event_name` LIKE '%quickplay%'
    AND DATE(TIMESTAMP_MICROS(`user_first_touch_timestamp`)) BETWEEN '2018-08-01' AND '2018-08-15'
  GROUP BY `event_name`
) AS t1
LEFT JOIN (
  SELECT initial.event_name, COUNT(DISTINCT initial.user_pseudo_id) AS returning_users
  FROM (
    SELECT `user_pseudo_id`, `event_name`
    FROM `firebase-public-project.analytics_153293282.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20180801' AND '20180815'
      AND `event_name` LIKE '%quickplay%'
      AND DATE(TIMESTAMP_MICROS(`user_first_touch_timestamp`)) BETWEEN '2018-08-01' AND '2018-08-15'
  ) AS initial
  INNER JOIN (
    SELECT `user_pseudo_id`
    FROM `firebase-public-project.analytics_153293282.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20180809' AND '20180829'
      AND TIMESTAMP_DIFF(TIMESTAMP_MICROS(`event_timestamp`), TIMESTAMP_MICROS(`user_first_touch_timestamp`), DAY) BETWEEN 8 AND 14
  ) AS retained
  ON initial.user_pseudo_id = retained.user_pseudo_id
  GROUP BY initial.event_name
) AS t2
ON t1.event_name = t2.event_name
ORDER BY Second_Week_Retention_Rate ASC
LIMIT 1;