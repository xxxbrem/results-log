WITH player_runs AS (
   SELECT b."match_id", b."striker", b."team_batting", SUM(s."runs_scored") AS "total_runs"
   FROM IPL.IPL.BALL_BY_BALL b
   JOIN IPL.IPL.BATSMAN_SCORED s
     ON b."match_id" = s."match_id"
        AND b."over_id" = s."over_id"
        AND b."ball_id" = s."ball_id"
        AND b."innings_no" = s."innings_no"
   GROUP BY b."match_id", b."striker", b."team_batting"
)
SELECT p."player_name" AS "striker_name",
       t."name" AS "team_name",
       pr."total_runs" AS "runs_scored",
       'Lost' AS "match_result"
FROM player_runs pr
JOIN IPL.IPL.MATCH m ON pr."match_id" = m."match_id"
JOIN IPL.IPL.PLAYER p ON pr."striker" = p."player_id"
JOIN IPL.IPL.TEAM t ON pr."team_batting" = t."team_id"
WHERE pr."total_runs" >= 100
  AND pr."team_batting" != m."match_winner";