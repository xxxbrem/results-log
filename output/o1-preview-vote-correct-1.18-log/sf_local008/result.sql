WITH

-- Calculate total games played per player
total_games AS (
  SELECT "player_id", SUM(COALESCE(TRY_TO_NUMBER("g"), 0)) AS total_games
  FROM BASEBALL.BASEBALL.BATTING
  GROUP BY "player_id"
),

max_total_games AS (
  SELECT MAX(total_games) AS max_games
  FROM total_games
),

players_max_games AS (
  SELECT t."player_id", t.total_games
  FROM total_games t
  JOIN max_total_games m ON t.total_games = m.max_games
),

-- Calculate total runs per player
total_runs AS (
  SELECT "player_id", SUM(COALESCE(TRY_TO_NUMBER("r"), 0)) AS total_runs
  FROM BASEBALL.BASEBALL.BATTING
  GROUP BY "player_id"
),

max_total_runs AS (
  SELECT MAX(total_runs) AS max_runs
  FROM total_runs
),

players_max_runs AS (
  SELECT t."player_id", t.total_runs
  FROM total_runs t
  JOIN max_total_runs m ON t.total_runs = m.max_runs
),

-- Calculate total hits per player
total_hits AS (
  SELECT "player_id", SUM(COALESCE(TRY_TO_NUMBER("h"), 0)) AS total_hits
  FROM BASEBALL.BASEBALL.BATTING
  GROUP BY "player_id"
),

max_total_hits AS (
  SELECT MAX(total_hits) AS max_hits
  FROM total_hits
),

players_max_hits AS (
  SELECT t."player_id", t.total_hits
  FROM total_hits t
  JOIN max_total_hits m ON t.total_hits = m.max_hits
),

-- Calculate total home runs per player
total_hr AS (
  SELECT "player_id", SUM(COALESCE(TRY_TO_NUMBER("hr"), 0)) AS total_hr
  FROM BASEBALL.BASEBALL.BATTING
  GROUP BY "player_id"
),

max_total_hr AS (
  SELECT MAX(total_hr) AS max_hr
  FROM total_hr
),

players_max_hr AS (
  SELECT t."player_id", t.total_hr
  FROM total_hr t
  JOIN max_total_hr m ON t.total_hr = m.max_hr
)

-- Final selection of statistics with corresponding players
SELECT 'Games Played' AS "Statistic", p."name_given" AS "Name", pg.total_games AS "Value"
FROM players_max_games pg
JOIN BASEBALL.BASEBALL.PLAYER p ON pg."player_id" = p."player_id"

UNION ALL

SELECT 'Runs' AS "Statistic", p."name_given" AS "Name", pr.total_runs AS "Value"
FROM players_max_runs pr
JOIN BASEBALL.BASEBALL.PLAYER p ON pr."player_id" = p."player_id"

UNION ALL

SELECT 'Hits' AS "Statistic", p."name_given" AS "Name", ph.total_hits AS "Value"
FROM players_max_hits ph
JOIN BASEBALL.BASEBALL.PLAYER p ON ph."player_id" = p."player_id"

UNION ALL

SELECT 'Home Runs' AS "Statistic", p."name_given" AS "Name", phr.total_hr AS "Value"
FROM players_max_hr phr
JOIN BASEBALL.BASEBALL.PLAYER p ON phr."player_id" = p."player_id"

ORDER BY
  CASE "Statistic"
    WHEN 'Games Played' THEN 1
    WHEN 'Runs' THEN 2
    WHEN 'Hits' THEN 3
    WHEN 'Home Runs' THEN 4
    ELSE 5
  END;