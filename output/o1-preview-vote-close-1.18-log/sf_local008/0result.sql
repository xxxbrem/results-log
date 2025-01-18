WITH "batting_numeric" AS (
    SELECT
        "player_id",
        CASE WHEN REGEXP_LIKE(TRIM("g"), '^[0-9]+$') THEN TO_NUMBER(TRIM("g")) ELSE NULL END AS "g_num",
        CASE WHEN REGEXP_LIKE(TRIM("r"), '^[0-9]+$') THEN TO_NUMBER(TRIM("r")) ELSE NULL END AS "r_num",
        CASE WHEN REGEXP_LIKE(TRIM("h"), '^[0-9]+$') THEN TO_NUMBER(TRIM("h")) ELSE NULL END AS "h_num",
        CASE WHEN REGEXP_LIKE(TRIM("hr"), '^[0-9]+$') THEN TO_NUMBER(TRIM("hr")) ELSE NULL END AS "hr_num"
        FROM BASEBALL.BASEBALL.BATTING
),
"player_totals" AS (
    SELECT
        "player_id",
        SUM("g_num") AS "Total_Games",
        SUM("r_num") AS "Total_Runs",
        SUM("h_num") AS "Total_Hits",
        SUM("hr_num") AS "Total_HomeRuns"
    FROM "batting_numeric"
    GROUP BY "player_id"
),
"max_values" AS (
    SELECT
        MAX("Total_Games") AS "Max_Games",
        MAX("Total_Runs") AS "Max_Runs",
        MAX("Total_Hits") AS "Max_Hits",
        MAX("Total_HomeRuns") AS "Max_HomeRuns"
    FROM "player_totals"
)
SELECT CONCAT(p."name_first", ' ', p."name_last") AS "GivenName", 'Games Played' AS "Statistic", t."Total_Games" AS "Value"
FROM "player_totals" t
JOIN BASEBALL.BASEBALL.PLAYER p ON t."player_id" = p."player_id"
WHERE t."Total_Games" = (SELECT "Max_Games" FROM "max_values")
UNION ALL
SELECT CONCAT(p."name_first", ' ', p."name_last") AS "GivenName", 'Runs' AS "Statistic", t."Total_Runs" AS "Value"
FROM "player_totals" t
JOIN BASEBALL.BASEBALL.PLAYER p ON t."player_id" = p."player_id"
WHERE t."Total_Runs" = (SELECT "Max_Runs" FROM "max_values")
UNION ALL
SELECT CONCAT(p."name_first", ' ', p."name_last") AS "GivenName", 'Hits' AS "Statistic", t."Total_Hits" AS "Value"
FROM "player_totals" t
JOIN BASEBALL.BASEBALL.PLAYER p ON t."player_id" = p."player_id"
WHERE t."Total_Hits" = (SELECT "Max_Hits" FROM "max_values")
UNION ALL
SELECT CONCAT(p."name_first", ' ', p."name_last") AS "GivenName", 'Home Runs' AS "Statistic", t."Total_HomeRuns" AS "Value"
FROM "player_totals" t
JOIN BASEBALL.BASEBALL.PLAYER p ON t."player_id" = p."player_id"
WHERE t."Total_HomeRuns" = (SELECT "Max_HomeRuns" FROM "max_values");