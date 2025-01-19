WITH player_scores AS (
  SELECT
    bs."match_id",
    bb."striker",
    bb."team_batting",
    SUM(bs."runs_scored") AS total_runs
  FROM IPL.IPL."BATSMAN_SCORED" bs
  JOIN IPL.IPL."BALL_BY_BALL" bb
    ON bs."match_id" = bb."match_id"
    AND bs."over_id" = bb."over_id"
    AND bs."ball_id" = bb."ball_id"
    AND bs."innings_no" = bb."innings_no"
  GROUP BY
    bs."match_id",
    bb."striker",
    bb."team_batting"
  HAVING SUM(bs."runs_scored") >= 100
)
SELECT DISTINCT p."player_name"
FROM player_scores ps
JOIN IPL.IPL."MATCH" m
  ON ps."match_id" = m."match_id"
JOIN IPL.IPL."PLAYER" p
  ON ps."striker" = p."player_id"
WHERE m."match_winner" IS NOT NULL
  AND ps."team_batting" <> m."match_winner";