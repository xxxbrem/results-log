WITH total_runs_per_player AS (
    SELECT bbb."striker" AS "player_id", SUM(bs."runs_scored") AS "total_runs"
    FROM "IPL"."IPL"."BATSMAN_SCORED" bs
    JOIN "IPL"."IPL"."BALL_BY_BALL" bbb
      ON bs."match_id" = bbb."match_id"
      AND bs."over_id" = bbb."over_id"
      AND bs."ball_id" = bbb."ball_id"
      AND bs."innings_no" = bbb."innings_no"
    WHERE bs."match_id" IN (
        SELECT "match_id"
        FROM "IPL"."IPL"."MATCH"
        WHERE "season_id" = 5
    )
    GROUP BY bbb."striker"
),
matches_played_per_player AS (
    SELECT "player_id", COUNT(DISTINCT "match_id") AS "matches_played"
    FROM "IPL"."IPL"."PLAYER_MATCH"
    WHERE "match_id" IN (
        SELECT "match_id"
        FROM "IPL"."IPL"."MATCH"
        WHERE "season_id" = 5
    )
    GROUP BY "player_id"
)
SELECT p."player_name" AS "Player_Name", 
       ROUND((trpp."total_runs"::FLOAT) / mpp."matches_played", 4) AS "Batting_Average"
FROM total_runs_per_player trpp
JOIN matches_played_per_player mpp ON trpp."player_id" = mpp."player_id"
JOIN "IPL"."IPL"."PLAYER" p ON trpp."player_id" = p."player_id"
ORDER BY "Batting_Average" DESC NULLS LAST
LIMIT 5;