WITH
TotalRuns AS (
  SELECT B."striker" AS "player_id", SUM(BS."runs_scored") AS "total_runs"
  FROM "IPL"."IPL"."BATSMAN_SCORED" BS
  JOIN "IPL"."IPL"."BALL_BY_BALL" B
    ON BS."match_id" = B."match_id"
    AND BS."over_id" = B."over_id"
    AND BS."ball_id" = B."ball_id"
    AND BS."innings_no" = B."innings_no"
  JOIN "IPL"."IPL"."MATCH" M
    ON BS."match_id" = M."match_id"
  WHERE M."season_id" = 5
  GROUP BY B."striker"
),
MatchesPlayed AS (
  SELECT PM."player_id", COUNT(DISTINCT PM."match_id") AS "matches_played"
  FROM "IPL"."IPL"."PLAYER_MATCH" PM
  JOIN "IPL"."IPL"."MATCH" M
    ON PM."match_id" = M."match_id"
  WHERE M."season_id" = 5
  GROUP BY PM."player_id"
),
Dismissals AS (
  SELECT WT."player_out" AS "player_id", COUNT(*) AS "dismissals"
  FROM "IPL"."IPL"."WICKET_TAKEN" WT
  JOIN "IPL"."IPL"."MATCH" M
    ON WT."match_id" = M."match_id"
  WHERE M."season_id" = 5
  GROUP BY WT."player_out"
),
PlayerStats AS (
  SELECT
    TR."player_id",
    TR."total_runs",
    MP."matches_played",
    COALESCE(D."dismissals", 0) AS "dismissals"
  FROM TotalRuns TR
  JOIN MatchesPlayed MP ON TR."player_id" = MP."player_id"
  LEFT JOIN Dismissals D ON TR."player_id" = D."player_id"
)
SELECT
  P."player_name",
  ROUND(PS."total_runs" / PS."matches_played", 4) AS "average_runs_per_match",
  CASE
    WHEN PS."dismissals" > 0 THEN ROUND(PS."total_runs" / PS."dismissals", 4)
    ELSE NULL
  END AS "batting_average"
FROM PlayerStats PS
JOIN "IPL"."IPL"."PLAYER" P ON PS."player_id" = P."player_id"
ORDER BY "average_runs_per_match" DESC NULLS LAST
LIMIT 5;