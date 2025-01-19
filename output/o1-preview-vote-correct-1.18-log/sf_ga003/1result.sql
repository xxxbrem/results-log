SELECT 
    "board" AS "board_type",
    ROUND(AVG("value"), 4) AS "average_score"
FROM (
    SELECT 
        MAX(CASE WHEN ep.VALUE:"key"::STRING = 'board' THEN ep.VALUE:"value":"string_value"::STRING END) AS "board",
        MAX(CASE WHEN ep.VALUE:"key"::STRING = 'value' THEN TRY_TO_NUMBER(
            COALESCE(
                ep.VALUE:"value":"string_value",
                ep.VALUE:"value":"int_value"::STRING,
                ep.VALUE:"value":"double_value"::STRING
            )
        ) END) AS "value"
    FROM "FIREBASE"."ANALYTICS_153293282"."EVENTS_20180915" t,
         LATERAL FLATTEN(input => t."event_params") ep
    WHERE t."event_name" = 'level_complete_quickplay'
    GROUP BY t."event_timestamp", t."user_pseudo_id"
) sub
WHERE "board" IS NOT NULL AND "value" IS NOT NULL
GROUP BY "board";