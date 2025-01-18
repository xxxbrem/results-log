WITH total_games AS (
  SELECT "player_id", SUM("g"::NUMBER) AS total_games
  FROM BASEBALL.BASEBALL.BATTING
  GROUP BY "player_id"
),
max_games AS (
  SELECT MAX(total_games) AS max_total_games FROM total_games
),
top_games_players AS (
  SELECT tg."player_id", tg.total_games
  FROM total_games tg
  WHERE tg.total_games = (SELECT max_total_games FROM max_games)
),
total_runs AS (
  SELECT "player_id", SUM("r"::NUMBER) AS total_runs
  FROM BASEBALL.BASEBALL.BATTING
  WHERE "r" != ''
  GROUP BY "player_id"
),
max_runs AS (
  SELECT MAX(total_runs) AS max_total_runs FROM total_runs
),
top_runs_players AS (
  SELECT tr."player_id", tr.total_runs
  FROM total_runs tr
  WHERE tr.total_runs = (SELECT max_total_runs FROM max_runs)
),
total_hits AS (
  SELECT "player_id", SUM("h"::NUMBER) AS total_hits
  FROM BASEBALL.BASEBALL.BATTING
  WHERE "h" != ''
  GROUP BY "player_id"
),
max_hits AS (
  SELECT MAX(total_hits) AS max_total_hits FROM total_hits
),
top_hits_players AS (
  SELECT th."player_id", th.total_hits
  FROM total_hits th
  WHERE th.total_hits = (SELECT max_total_hits FROM max_hits)
),
total_home_runs AS (
  SELECT "player_id", SUM("hr"::NUMBER) AS total_home_runs
  FROM BASEBALL.BASEBALL.BATTING
  WHERE "hr" != ''
  GROUP BY "player_id"
),
max_home_runs AS (
  SELECT MAX(total_home_runs) AS max_total_home_runs FROM total_home_runs
),
top_hr_players AS (
  SELECT thr."player_id", thr.total_home_runs
  FROM total_home_runs thr
  WHERE thr.total_home_runs = (SELECT max_total_home_runs FROM max_home_runs)
)
SELECT 'Games Played' AS "Statistic", p."name_first" AS "GivenName", CAST(tgp.total_games AS VARCHAR) AS "Value"
FROM top_games_players tgp
JOIN BASEBALL.BASEBALL.PLAYER p ON tgp."player_id" = p."player_id"
UNION ALL
SELECT 'Runs' AS "Statistic", p."name_first" AS "GivenName", CAST(trp.total_runs AS VARCHAR) AS "Value"
FROM top_runs_players trp
JOIN BASEBALL.BASEBALL.PLAYER p ON trp."player_id" = p."player_id"
UNION ALL
SELECT 'Hits' AS "Statistic", p."name_first" AS "GivenName", CAST(thp.total_hits AS VARCHAR) AS "Value"
FROM top_hits_players thp
JOIN BASEBALL.BASEBALL.PLAYER p ON thp."player_id" = p."player_id"
UNION ALL
SELECT 'Home Runs' AS "Statistic", p."name_first" AS "GivenName", CAST(thrp.total_home_runs AS VARCHAR) AS "Value"
FROM top_hr_players thrp
JOIN BASEBALL.BASEBALL.PLAYER p ON thrp."player_id" = p."player_id";