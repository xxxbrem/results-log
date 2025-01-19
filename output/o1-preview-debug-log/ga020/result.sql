WITH initial_engagement AS (
  SELECT
    user_pseudo_id,
    LOWER(event_name) AS event_type,
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_engagement_date
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20180801' AND '20180815'
    AND LOWER(event_name) LIKE '%quickplay%'
  GROUP BY user_pseudo_id, event_type
),
second_week_engagement AS (
  SELECT DISTINCT
    t.user_pseudo_id,
    LOWER(t.event_name) AS event_type
  FROM `firebase-public-project.analytics_153293282.events_*` AS t
  JOIN initial_engagement AS i
    ON t.user_pseudo_id = i.user_pseudo_id
    AND LOWER(t.event_name) = i.event_type
  WHERE PARSE_DATE('%Y%m%d', t.event_date) BETWEEN DATE_ADD(i.first_engagement_date, INTERVAL 7 DAY) AND DATE_ADD(i.first_engagement_date, INTERVAL 14 DAY)
    AND LOWER(t.event_name) LIKE '%quickplay%'
),
retention AS (
  SELECT
    i.event_type,
    COUNT(DISTINCT i.user_pseudo_id) AS initial_users,
    COUNT(DISTINCT s.user_pseudo_id) AS retained_users
  FROM initial_engagement AS i
  LEFT JOIN second_week_engagement AS s
    ON i.user_pseudo_id = s.user_pseudo_id
    AND i.event_type = s.event_type
  GROUP BY i.event_type
)
SELECT event_type AS Event_type,
       ROUND((CAST(retained_users AS FLOAT64) / initial_users) * 100, 4) AS Second_week_retention_rate
FROM retention
ORDER BY Second_week_retention_rate ASC
LIMIT 1