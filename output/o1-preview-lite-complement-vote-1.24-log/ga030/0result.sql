WITH first_week AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d', MIN(event_date)), WEEK(MONDAY)) AS first_week_monday
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE event_date >= '20180702'
  GROUP BY user_pseudo_id
),
user_events AS (
  SELECT
    e.user_pseudo_id,
    fw.first_week_monday,
    PARSE_DATE('%Y%m%d', e.event_date) AS event_date,
    DATE_DIFF(PARSE_DATE('%Y%m%d', e.event_date), fw.first_week_monday, WEEK) AS weeks_since_first_week
  FROM `firebase-public-project.analytics_153293282.events_*` e
  JOIN first_week fw ON e.user_pseudo_id = fw.user_pseudo_id
  WHERE PARSE_DATE('%Y%m%d', e.event_date) >= fw.first_week_monday
)
SELECT
  Week_start_date
FROM (
  SELECT 
    first_week_monday AS Week_start_date,
    COUNT(DISTINCT user_pseudo_id) AS total_users_in_group,
    COUNT(DISTINCT CASE 
      WHEN weeks_since_first_week BETWEEN 1 AND 4 THEN user_pseudo_id 
    END) AS active_users_in_next_four_weeks
  FROM user_events
  GROUP BY first_week_monday
  ORDER BY active_users_in_next_four_weeks DESC
  LIMIT 1
)