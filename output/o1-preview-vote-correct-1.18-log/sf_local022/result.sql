SELECT DISTINCT p."player_name" AS striker_name
FROM (
  SELECT bbb."match_id", bbb."striker", SUM(bs."runs_scored") AS total_runs
  FROM IPL.IPL."BALL_BY_BALL" bbb
  JOIN IPL.IPL."BATSMAN_SCORED" bs
    ON bbb."match_id" = bs."match_id"
    AND bbb."over_id" = bs."over_id"
    AND bbb."ball_id" = bs."ball_id"
    AND bbb."innings_no" = bs."innings_no"
  GROUP BY bbb."match_id", bbb."striker"
  HAVING SUM(bs."runs_scored") >= 100
) t
JOIN IPL.IPL."PLAYER" p ON t."striker" = p."player_id"
JOIN IPL.IPL."PLAYER_MATCH" pm ON t."match_id" = pm."match_id" AND t."striker" = pm."player_id"
JOIN IPL.IPL."MATCH" m ON t."match_id" = m."match_id"
WHERE pm."team_id" <> m."match_winner";