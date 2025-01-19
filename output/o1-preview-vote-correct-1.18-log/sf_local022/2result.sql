SELECT DISTINCT
  p."player_name"
FROM IPL.IPL.BATSMAN_SCORED bs
JOIN IPL.IPL.BALL_BY_BALL bb
  ON bs."match_id" = bb."match_id"
  AND bs."over_id" = bb."over_id"
  AND bs."ball_id" = bb."ball_id"
  AND bs."innings_no" = bb."innings_no"
JOIN IPL.IPL.MATCH m
  ON bb."match_id" = m."match_id"
JOIN IPL.IPL.PLAYER p
  ON bb."striker" = p."player_id"
GROUP BY bb."match_id", bb."striker", bb."team_batting", m."match_winner", m."outcome_type", p."player_name"
HAVING SUM(bs."runs_scored") >= 100
  AND m."outcome_type" = 'Result'
  AND bb."team_batting" != m."match_winner";