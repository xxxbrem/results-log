SELECT 'Games Played' AS "Stat", p."name_given" AS "Given_Name", t."Score"
FROM (
    SELECT "player_id", SUM("g") AS "Score"
    FROM "batting"
    GROUP BY "player_id"
    ORDER BY "Score" DESC
    LIMIT 1
) t
JOIN "player" p ON t."player_id" = p."player_id"
UNION ALL
SELECT 'Runs' AS "Stat", p."name_given" AS "Given_Name", t."Score"
FROM (
    SELECT "player_id", SUM("r") AS "Score"
    FROM "batting"
    GROUP BY "player_id"
    ORDER BY "Score" DESC
    LIMIT 1
) t
JOIN "player" p ON t."player_id" = p."player_id"
UNION ALL
SELECT 'Hits' AS "Stat", p."name_given" AS "Given_Name", t."Score"
FROM (
    SELECT "player_id", SUM("h") AS "Score"
    FROM "batting"
    GROUP BY "player_id"
    ORDER BY "Score" DESC
    LIMIT 1
) t
JOIN "player" p ON t."player_id" = p."player_id"
UNION ALL
SELECT 'Home Runs' AS "Stat", p."name_given" AS "Given_Name", t."Score"
FROM (
    SELECT "player_id", SUM("hr") AS "Score"
    FROM "batting"
    GROUP BY "player_id"
    ORDER BY "Score" DESC
    LIMIT 1
) t
JOIN "player" p ON t."player_id" = p."player_id";