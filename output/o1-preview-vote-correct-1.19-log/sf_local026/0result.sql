SELECT 
    p."player_name" AS "bowler_name",
    t."match_id",
    t."over_id",
    t."total_runs_conceded"
FROM (
    SELECT 
        b."bowler",
        b."match_id",
        b."over_id",
        SUM(COALESCE(s."runs_scored", 0) + COALESCE(e."extra_runs", 0)) AS "total_runs_conceded"
    FROM IPL.IPL."BALL_BY_BALL" b
    LEFT JOIN IPL.IPL."BATSMAN_SCORED" s
        ON b."match_id" = s."match_id"
        AND b."innings_no" = s."innings_no"
        AND b."over_id" = s."over_id"
        AND b."ball_id" = s."ball_id"
    LEFT JOIN IPL.IPL."EXTRA_RUNS" e
        ON b."match_id" = e."match_id"
        AND b."innings_no" = e."innings_no"
        AND b."over_id" = e."over_id"
        AND b."ball_id" = e."ball_id"
    GROUP BY b."bowler", b."match_id", b."over_id"
) t
INNER JOIN IPL.IPL."PLAYER" p
    ON t."bowler" = p."player_id"
ORDER BY t."total_runs_conceded" DESC NULLS LAST
LIMIT 3