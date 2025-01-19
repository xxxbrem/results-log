SELECT
  board_type,
  ROUND(AVG(score), 4) AS average_score
FROM (
  SELECT
    t.event_timestamp,
    MAX(CASE WHEN ep.key = 'value' THEN CAST(ep.value.int_value AS INT64) END) AS score,
    MAX(CASE WHEN ep.key = 'board' THEN ep.value.string_value END) AS board_type
  FROM
    `firebase-public-project.analytics_153293282.events_20180915` AS t
  JOIN
    UNNEST(t.event_params) AS ep
  ON
    TRUE
  WHERE
    t.event_name = 'level_complete_quickplay'
  GROUP BY
    t.event_timestamp
)
WHERE
  score IS NOT NULL AND board_type IS NOT NULL
GROUP BY
  board_type
ORDER BY
  average_score DESC;