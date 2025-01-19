SELECT 
    p."name_given" || ' ' || p."name_last" AS "Given_name",
    'Games Played' AS "Statistic",
    TO_CHAR(gp."total_games", 'FM9999999999999999.0000') AS "Value"
FROM (
    SELECT "player_id", SUM(COALESCE(TRY_TO_NUMBER("g"), 0)) AS "total_games"
    FROM "BASEBALL"."BASEBALL"."BATTING"
    GROUP BY "player_id"
    ORDER BY "total_games" DESC NULLS LAST
    LIMIT 1
) gp
JOIN "BASEBALL"."BASEBALL"."PLAYER" p ON gp."player_id" = p."player_id"

UNION ALL

SELECT 
    p."name_given" || ' ' || p."name_last" AS "Given_name",
    'Runs' AS "Statistic",
    TO_CHAR(r."total_runs", 'FM9999999999999999.0000') AS "Value"
FROM (
    SELECT "player_id", SUM(COALESCE(TRY_TO_NUMBER("r"), 0)) AS "total_runs"
    FROM "BASEBALL"."BASEBALL"."BATTING"
    GROUP BY "player_id"
    ORDER BY "total_runs" DESC NULLS LAST
    LIMIT 1
) r
JOIN "BASEBALL"."BASEBALL"."PLAYER" p ON r."player_id" = p."player_id"

UNION ALL

SELECT 
    p."name_given" || ' ' || p."name_last" AS "Given_name",
    'Hits' AS "Statistic",
    TO_CHAR(h."total_hits", 'FM9999999999999999.0000') AS "Value"
FROM (
    SELECT "player_id", SUM(COALESCE(TRY_TO_NUMBER("h"), 0)) AS "total_hits"
    FROM "BASEBALL"."BASEBALL"."BATTING"
    GROUP BY "player_id"
    ORDER BY "total_hits" DESC NULLS LAST
    LIMIT 1
) h
JOIN "BASEBALL"."BASEBALL"."PLAYER" p ON h."player_id" = p."player_id"

UNION ALL

SELECT 
    p."name_given" || ' ' || p."name_last" AS "Given_name",
    'Home Runs' AS "Statistic",
    TO_CHAR(hr."total_home_runs", 'FM9999999999999999.0000') AS "Value"
FROM (
    SELECT "player_id", SUM(COALESCE(TRY_TO_NUMBER("hr"), 0)) AS "total_home_runs"
    FROM "BASEBALL"."BASEBALL"."BATTING"
    GROUP BY "player_id"
    ORDER BY "total_home_runs" DESC NULLS LAST
    LIMIT 1
) hr
JOIN "BASEBALL"."BASEBALL"."PLAYER" p ON hr."player_id" = p."player_id";