SELECT
    p."player_name",
    ROUND(total_runs / matches_played, 4) AS "Average_Runs_per_Match",
    ROUND(total_runs / NULLIF(dismissals, 0), 4) AS "Batting_Average"
FROM (
    -- Calculate total runs per player in season 5
    SELECT
        b."striker" AS "player_id",
        SUM(bs."runs_scored") AS total_runs
    FROM IPL.IPL."BATSMAN_SCORED" bs
    JOIN IPL.IPL."BALL_BY_BALL" b ON bs."match_id" = b."match_id"
        AND bs."over_id" = b."over_id"
        AND bs."ball_id" = b."ball_id"
        AND bs."innings_no" = b."innings_no"
    JOIN IPL.IPL."MATCH" m ON bs."match_id" = m."match_id"
    WHERE m."season_id" = 5
    GROUP BY b."striker"
) total_runs_per_player
JOIN (
    -- Calculate matches played per player in season 5
    SELECT
        pm."player_id",
        COUNT(DISTINCT pm."match_id") AS matches_played
    FROM IPL.IPL."PLAYER_MATCH" pm
    JOIN IPL.IPL."MATCH" m ON pm."match_id" = m."match_id"
    WHERE m."season_id" = 5
    GROUP BY pm."player_id"
) matches_per_player ON total_runs_per_player."player_id" = matches_per_player."player_id"
LEFT JOIN (
    -- Calculate number of times each player was dismissed in season 5
    SELECT
        wt."player_out" AS "player_id",
        COUNT(*) AS dismissals
    FROM IPL.IPL."WICKET_TAKEN" wt
    JOIN IPL.IPL."MATCH" m ON wt."match_id" = m."match_id"
    WHERE m."season_id" = 5
    GROUP BY wt."player_out"
) dismissals_per_player ON total_runs_per_player."player_id" = dismissals_per_player."player_id"
JOIN IPL.IPL."PLAYER" p ON total_runs_per_player."player_id" = p."player_id"
ORDER BY (total_runs / matches_played) DESC NULLS LAST
LIMIT 5;