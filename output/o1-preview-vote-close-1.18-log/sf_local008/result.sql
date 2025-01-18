WITH max_games_played AS (
    SELECT
        'Games Played' AS "Stat",
        p."name_first" AS "Given_name",
        SUM(TRY_TO_NUMBER(b."g")) AS "Value"
    FROM
        BASEBALL.BASEBALL.BATTING b
    JOIN
        BASEBALL.BASEBALL.PLAYER p ON b."player_id" = p."player_id"
    GROUP BY
        b."player_id", p."name_first"
    ORDER BY
        "Value" DESC NULLS LAST
    LIMIT 1
),
max_runs AS (
    SELECT
        'Runs' AS "Stat",
        p."name_first" AS "Given_name",
        SUM(TRY_TO_NUMBER(b."r")) AS "Value"
    FROM
        BASEBALL.BASEBALL.BATTING b
    JOIN
        BASEBALL.BASEBALL.PLAYER p ON b."player_id" = p."player_id"
    GROUP BY
        b."player_id", p."name_first"
    ORDER BY
        "Value" DESC NULLS LAST
    LIMIT 1
),
max_hits AS (
    SELECT
        'Hits' AS "Stat",
        p."name_first" AS "Given_name",
        SUM(TRY_TO_NUMBER(b."h")) AS "Value"
    FROM
        BASEBALL.BASEBALL.BATTING b
    JOIN
        BASEBALL.BASEBALL.PLAYER p ON b."player_id" = p."player_id"
    GROUP BY
        b."player_id", p."name_first"
    ORDER BY
        "Value" DESC NULLS LAST
    LIMIT 1
),
max_home_runs AS (
    SELECT
        'Home Runs' AS "Stat",
        p."name_first" AS "Given_name",
        SUM(TRY_TO_NUMBER(b."hr")) AS "Value"
    FROM
        BASEBALL.BASEBALL.BATTING b
    JOIN
        BASEBALL.BASEBALL.PLAYER p ON b."player_id" = p."player_id"
    GROUP BY
        b."player_id", p."name_first"
    ORDER BY
        "Value" DESC NULLS LAST
    LIMIT 1
)
SELECT * FROM max_games_played
UNION ALL
SELECT * FROM max_runs
UNION ALL
SELECT * FROM max_hits
UNION ALL
SELECT * FROM max_home_runs;