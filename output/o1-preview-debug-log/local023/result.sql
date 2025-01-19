WITH season5_matches AS (
    SELECT "match_id"
    FROM "match"
    WHERE "season_id" = 5
),
player_matches AS (
    SELECT "player_id", COUNT(DISTINCT "match_id") AS "matches_played"
    FROM "player_match"
    WHERE "match_id" IN (SELECT "match_id" FROM season5_matches)
        AND "role" != 'Substitute'
    GROUP BY "player_id"
),
player_runs AS (
    SELECT bb."striker" AS "player_id", SUM(bs."runs_scored") AS "total_runs"
    FROM "ball_by_ball" bb
    JOIN "batsman_scored" bs 
      ON bb."match_id" = bs."match_id" 
     AND bb."over_id" = bs."over_id" 
     AND bb."ball_id" = bs."ball_id" 
     AND bb."innings_no" = bs."innings_no"
    WHERE bb."match_id" IN (SELECT "match_id" FROM season5_matches)
    GROUP BY bb."striker"
)
SELECT "p"."player_name" AS "Player_name",
       ROUND(("pr"."total_runs" * 1.0) / "pm"."matches_played", 4) AS "Batting_average"
FROM "player_runs" AS "pr"
JOIN "player_matches" AS "pm" ON "pr"."player_id" = "pm"."player_id"
JOIN "player" AS "p" ON "pr"."player_id" = "p"."player_id"
ORDER BY "Batting_average" DESC, "p"."player_name"
LIMIT 5;