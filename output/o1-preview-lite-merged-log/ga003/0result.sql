SELECT
  board_type,
  ROUND(AVG(score), 4) AS average_score
FROM (
  SELECT
    (SELECT param.value.string_value 
     FROM UNNEST(event_params) AS param 
     WHERE param.key = 'level_name') AS board_type,
    (SELECT 
        COALESCE(
          param.value.int_value, 
          param.value.float_value,
          param.value.double_value,
          SAFE_CAST(param.value.string_value AS FLOAT64)
        ) 
     FROM UNNEST(event_params) AS param 
     WHERE param.key = 'value') AS score
  FROM `firebase-public-project.analytics_153293282.events_20180915`
  WHERE event_name = 'level_complete'
)
WHERE board_type IS NOT NULL AND score IS NOT NULL
GROUP BY board_type
ORDER BY average_score DESC;