SELECT ROUND(AVG(engaged_sessions), 4) AS average_engaged_sessions_per_user
FROM (
  SELECT
    user_pseudo_id,
    COUNT(DISTINCT ga_session_id) AS engaged_sessions
  FROM (
    SELECT
      user_pseudo_id,
      (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
      (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'engagement_time_msec') AS engagement_time_msec
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_date BETWEEN '20201201' AND '20201231'
  )
  WHERE engagement_time_msec >= 10000
  GROUP BY user_pseudo_id
);