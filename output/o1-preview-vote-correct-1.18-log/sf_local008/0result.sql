SELECT p."name_first" AS "Given_Name", 'Games Played' AS "Statistic", CAST(t.total_games AS VARCHAR) AS "Value"
FROM (
    SELECT b."player_id", SUM(TRY_TO_NUMBER(b."g")) AS total_games,
        ROW_NUMBER() OVER (ORDER BY SUM(TRY_TO_NUMBER(b."g")) DESC NULLS LAST) AS rn
    FROM BASEBALL.BASEBALL.BATTING b
    GROUP BY b."player_id"
) t
JOIN BASEBALL.BASEBALL.PLAYER p ON t."player_id" = p."player_id"
WHERE t.rn = 1

UNION ALL

SELECT p."name_first" AS "Given_Name", 'Runs' AS "Statistic", CAST(t.total_runs AS VARCHAR) AS "Value"
FROM (
    SELECT b."player_id", SUM(TRY_TO_NUMBER(b."r")) AS total_runs,
        ROW_NUMBER() OVER (ORDER BY SUM(TRY_TO_NUMBER(b."r")) DESC NULLS LAST) AS rn
    FROM BASEBALL.BASEBALL.BATTING b
    GROUP BY b."player_id"
) t
JOIN BASEBALL.BASEBALL.PLAYER p ON t."player_id" = p."player_id"
WHERE t.rn = 1

UNION ALL

SELECT p."name_first" AS "Given_Name", 'Hits' AS "Statistic", CAST(t.total_hits AS VARCHAR) AS "Value"
FROM (
    SELECT b."player_id", SUM(TRY_TO_NUMBER(b."h")) AS total_hits,
        ROW_NUMBER() OVER (ORDER BY SUM(TRY_TO_NUMBER(b."h")) DESC NULLS LAST) AS rn
    FROM BASEBALL.BASEBALL.BATTING b
    GROUP BY b."player_id"
) t
JOIN BASEBALL.BASEBALL.PLAYER p ON t."player_id" = p."player_id"
WHERE t.rn = 1

UNION ALL

SELECT p."name_first" AS "Given_Name", 'Home Runs' AS "Statistic", CAST(t.total_hr AS VARCHAR) AS "Value"
FROM (
    SELECT b."player_id", SUM(TRY_TO_NUMBER(b."hr")) AS total_hr,
        ROW_NUMBER() OVER (ORDER BY SUM(TRY_TO_NUMBER(b."hr")) DESC NULLS LAST) AS rn
    FROM BASEBALL.BASEBALL.BATTING b
    GROUP BY b."player_id"
) t
JOIN BASEBALL.BASEBALL.PLAYER p ON t."player_id" = p."player_id"
WHERE t.rn = 1