WITH season5_matches AS (
    SELECT "match_id"
    FROM IPL.IPL.MATCH
    WHERE "season_id" = 5
), runs_per_player AS (
    SELECT bbb."striker" AS "player_id", SUM(bs."runs_scored") AS total_runs
    FROM IPL.IPL.BATSMAN_SCORED bs
    JOIN IPL.IPL.BALL_BY_BALL bbb
        ON bs."match_id" = bbb."match_id"
        AND bs."innings_no" = bbb."innings_no"
        AND bs."over_id" = bbb."over_id"
        AND bs."ball_id" = bbb."ball_id"
    WHERE bs."match_id" IN (SELECT "match_id" FROM season5_matches)
    GROUP BY bbb."striker"
), times_out AS (
    SELECT wt."player_out" AS "player_id", COUNT(*) AS times_out
    FROM IPL.IPL.WICKET_TAKEN wt
    WHERE wt."match_id" IN (SELECT "match_id" FROM season5_matches)
    GROUP BY wt."player_out"
), matches_played AS (
    SELECT pm."player_id", COUNT(DISTINCT pm."match_id") AS matches_played
    FROM IPL.IPL.PLAYER_MATCH pm
    WHERE pm."match_id" IN (SELECT "match_id" FROM season5_matches)
    GROUP BY pm."player_id"
)
SELECT p."player_name",
       ROUND(CAST(rp.total_runs AS DECIMAL) / mp.matches_played, 4) AS average_runs_per_match,
       ROUND(CAST(rp.total_runs AS DECIMAL) / NULLIF(times_out.times_out, 0), 4) AS batting_average
FROM runs_per_player rp
JOIN IPL.IPL.PLAYER p ON rp."player_id" = p."player_id"
JOIN matches_played mp ON rp."player_id" = mp."player_id"
LEFT JOIN times_out ON rp."player_id" = times_out."player_id"
WHERE rp.total_runs IS NOT NULL AND mp.matches_played > 0
ORDER BY average_runs_per_match DESC NULLS LAST
LIMIT 5;