SELECT p."player_name" AS "Bowler_Name",
       SUM(COALESCE(bs."runs_scored", 0) + COALESCE(er."extra_runs", 0)) AS "Total_Runs_Conceded_In_Over",
       bb."match_id" AS "Match_ID",
       bb."over_id" AS "Over_ID"
FROM "ball_by_ball" AS bb
LEFT JOIN "batsman_scored" AS bs ON
  bb."match_id" = bs."match_id" AND
  bb."over_id" = bs."over_id" AND
  bb."ball_id" = bs."ball_id" AND
  bb."innings_no" = bs."innings_no"
LEFT JOIN "extra_runs" AS er ON
  bb."match_id" = er."match_id" AND
  bb."over_id" = er."over_id" AND
  bb."ball_id" = er."ball_id" AND
  bb."innings_no" = er."innings_no"
JOIN "player" AS p ON
  bb."bowler" = p."player_id"
GROUP BY bb."match_id", bb."over_id", bb."bowler", p."player_name"
ORDER BY "Total_Runs_Conceded_In_Over" DESC
LIMIT 3;