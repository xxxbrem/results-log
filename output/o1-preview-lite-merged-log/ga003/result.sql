SELECT
  params.board AS board_type,
  ROUND(AVG(params.score), 4) AS average_score
FROM (
  SELECT
    (
      SELECT AS STRUCT
        MAX(IF(ep.key = 'board', ep.value.string_value, NULL)) AS board,
        MAX(
          IF(ep.key = 'value',
            COALESCE(
              ep.value.int_value,
              ep.value.float_value,
              ep.value.double_value,
              SAFE_CAST(ep.value.string_value AS FLOAT64)
            ),
            NULL
          )
        ) AS score
      FROM UNNEST(e.event_params) AS ep
    ) AS params
  FROM `firebase-public-project.analytics_153293282.events_20180915` AS e
  WHERE e.event_name = 'level_complete_quickplay'
) AS subquery
WHERE params.board IS NOT NULL AND params.score IS NOT NULL
GROUP BY board_type
ORDER BY board_type;