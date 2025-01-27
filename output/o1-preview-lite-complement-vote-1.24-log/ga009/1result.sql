SELECT
  ROUND(AVG(engaged_sessions_count), 4) AS average_engaged_sessions_per_user
FROM (
  SELECT
    `user_pseudo_id`,
    COUNT(DISTINCT ep_session_id.value.int_value) AS engaged_sessions_count
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(`event_params`) AS ep_session_id,
    UNNEST(`event_params`) AS ep_session_engaged
  WHERE ep_session_id.key = 'ga_session_id'
    AND ep_session_engaged.key = 'session_engaged'
    AND ep_session_engaged.value.int_value = 1
    AND `event_date` BETWEEN '20201201' AND '20201231'
    AND _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
  GROUP BY `user_pseudo_id`
)