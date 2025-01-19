WITH "event_data" AS (
  SELECT
    t."event_timestamp",
    MAX(CASE WHEN f.value:"key"::STRING = 'board' THEN f.value:"value":"string_value"::STRING END) AS "board_type",
    MAX(CASE WHEN f.value:"key"::STRING = 'value' THEN f.value:"value":"int_value"::FLOAT END) AS "score"
  FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180915" AS t,
       LATERAL FLATTEN(input => t."event_params") AS f
  WHERE t."event_name" = 'level_complete_quickplay'
  GROUP BY t."event_timestamp"
)
SELECT
  "board_type",
  ROUND(AVG("score"), 4) AS "average_score"
FROM "event_data"
GROUP BY "board_type"
ORDER BY "board_type";