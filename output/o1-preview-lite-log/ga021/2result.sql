SELECT
  initial_users.quickplay_event_type AS Quickplay_Event_Type,
  ROUND(
    COUNT(DISTINCT retained_users.user_pseudo_id) * 100.0 / COUNT(DISTINCT initial_users.user_pseudo_id),
    4
  ) AS Retention_Rate
FROM (
  SELECT
    user_pseudo_id,
    MIN(event_date) AS initial_event_date,
    event_name AS quickplay_event_type
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE event_name LIKE '%quickplay%'
    AND event_date BETWEEN '20180702' AND '20180716'
  GROUP BY user_pseudo_id, event_name
) AS initial_users
LEFT JOIN `firebase-public-project.analytics_153293282.events_*` AS retained_users
  ON initial_users.user_pseudo_id = retained_users.user_pseudo_id
  AND DATE_DIFF(
    PARSE_DATE('%Y%m%d', retained_users.event_date),
    PARSE_DATE('%Y%m%d', initial_users.initial_event_date),
    DAY
  ) BETWEEN 14 AND 28
GROUP BY Quickplay_Event_Type
ORDER BY Quickplay_Event_Type;