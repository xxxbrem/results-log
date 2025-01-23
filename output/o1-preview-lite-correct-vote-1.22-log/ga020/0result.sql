WITH initial_users AS (
  SELECT DISTINCT user_pseudo_id, user_first_touch_timestamp
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180801' AND '20180815'
    AND DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)) BETWEEN '2018-08-01' AND '2018-08-15'
),

user_initial_quickplay AS (
  SELECT
    iu.user_pseudo_id,
    ep.value.string_value AS initial_quickplay_type,
    iu.user_first_touch_timestamp
  FROM initial_users iu
  JOIN `firebase-public-project.analytics_153293282.events_*` e
    ON e.user_pseudo_id = iu.user_pseudo_id
  LEFT JOIN UNNEST(e.event_params) AS ep
    ON TRUE
  WHERE
    _TABLE_SUFFIX BETWEEN '20180801' AND '20180815'
    AND LOWER(e.event_name) LIKE '%quickplay%'
    AND ep.key = 'board'
    AND ep.value.string_value IS NOT NULL
  QUALIFY ROW_NUMBER() OVER (PARTITION BY iu.user_pseudo_id ORDER BY e.event_timestamp) = 1
),

users_total_by_type AS (
  SELECT
    initial_quickplay_type AS Event_Type,
    COUNT(DISTINCT user_pseudo_id) AS total_users
  FROM user_initial_quickplay
  GROUP BY Event_Type
),

users_returned_in_second_week AS (
  SELECT DISTINCT
    uiq.user_pseudo_id,
    uiq.initial_quickplay_type AS Event_Type
  FROM user_initial_quickplay uiq
  JOIN `firebase-public-project.analytics_153293282.events_*` e
    ON e.user_pseudo_id = uiq.user_pseudo_id
  WHERE
    TIMESTAMP_DIFF(TIMESTAMP_MICROS(e.event_timestamp), TIMESTAMP_MICROS(uiq.user_first_touch_timestamp), DAY) BETWEEN 7 AND 14
),

users_returned_by_type AS (
  SELECT
    Event_Type,
    COUNT(DISTINCT user_pseudo_id) AS returned_users
  FROM users_returned_in_second_week
  GROUP BY Event_Type
),

retention_rate AS (
  SELECT
    tt.Event_Type,
    ROUND(SAFE_DIVIDE(rt.returned_users, tt.total_users), 4) AS Second_Week_Retention_Rate
  FROM users_total_by_type tt
  LEFT JOIN users_returned_by_type rt
    ON tt.Event_Type = rt.Event_Type
)

SELECT
  Event_Type,
  Second_Week_Retention_Rate
FROM retention_rate
ORDER BY Second_Week_Retention_Rate
LIMIT 1;