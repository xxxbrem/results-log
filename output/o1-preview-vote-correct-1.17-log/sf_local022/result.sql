WITH batsman_runs AS (
    SELECT 
        tbb."match_id",
        tbb."striker",
        tbb."team_batting",
        SUM(bs."runs_scored") AS total_runs
    FROM IPL.IPL."BATSMAN_SCORED" bs
    JOIN IPL.IPL."BALL_BY_BALL" tbb
        ON bs."match_id" = tbb."match_id" 
        AND bs."over_id" = tbb."over_id" 
        AND bs."ball_id" = tbb."ball_id"
        AND bs."innings_no" = tbb."innings_no"
    GROUP BY 
        tbb."match_id", 
        tbb."striker", 
        tbb."team_batting"
)
SELECT DISTINCT p."player_name"
FROM batsman_runs br
JOIN IPL.IPL."PLAYER" p 
    ON br."striker" = p."player_id"
JOIN IPL.IPL."MATCH" m 
    ON br."match_id" = m."match_id"
WHERE 
    br.total_runs >= 100
    AND br."team_batting" != m."match_winner";