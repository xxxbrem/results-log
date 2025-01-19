WITH season_5_matches AS (
    SELECT "match_id"
    FROM IPL.IPL."MATCH"
    WHERE "season_id" = 5
),
total_runs_per_player AS (
    SELECT bbb."striker" AS "player_id", SUM(bs."runs_scored") AS total_runs
    FROM IPL.IPL."BATSMAN_SCORED" bs
    JOIN IPL.IPL."BALL_BY_BALL" bbb ON bs."match_id" = bbb."match_id"
      AND bs."over_id" = bbb."over_id"
      AND bs."ball_id" = bbb."ball_id"
      AND bs."innings_no" = bbb."innings_no"
    WHERE bs."match_id" IN (SELECT "match_id" FROM season_5_matches)
    GROUP BY bbb."striker"
),
matches_played_per_player AS (
    SELECT bbb."striker" AS "player_id", COUNT(DISTINCT bbb."match_id") AS matches_played
    FROM IPL.IPL."BALL_BY_BALL" bbb
    WHERE bbb."match_id" IN (SELECT "match_id" FROM season_5_matches)
    GROUP BY bbb."striker"
),
times_dismissed_per_player AS (
    SELECT wt."player_out" AS "player_id", COUNT(*) AS times_dismissed
    FROM IPL.IPL."WICKET_TAKEN" wt
    WHERE wt."match_id" IN (SELECT "match_id" FROM season_5_matches)
    GROUP BY wt."player_out"
)
SELECT p."player_name" AS "Name",
       ROUND(CASE 
            WHEN tdp.times_dismissed > 0 THEN trp.total_runs * 1.0 / tdp.times_dismissed
            ELSE trp.total_runs
       END, 4) AS "Batting_Average"
FROM total_runs_per_player trp
JOIN matches_played_per_player mpp ON trp."player_id" = mpp."player_id"
LEFT JOIN times_dismissed_per_player tdp ON trp."player_id" = tdp."player_id"
JOIN IPL.IPL."PLAYER" p ON trp."player_id" = p."player_id"
ORDER BY (trp.total_runs * 1.0 / mpp.matches_played) DESC NULLS LAST
LIMIT 5;