SELECT
  AVG(engaged_sessions) AS average_engaged_sessions_per_user
FROM (
  SELECT
    user_pseudo_id,
    COUNT(DISTINCT ga_session_id) AS engaged_sessions
  FROM (
    SELECT
      user_pseudo_id,
      (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
      (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'session_engaged') AS session_engaged
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
  ) AS sessions
  WHERE session_engaged = 1 AND ga_session_id IS NOT NULL
  GROUP BY user_pseudo_id
)