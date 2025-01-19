SELECT
    t."Bowler_name",
    t."Match_id",
    CAST(t."Runs_conceded_in_over" AS DECIMAL(10,4)) AS "Runs_conceded_in_over"
FROM (
    SELECT
        p."player_name" AS "Bowler_name",
        b."match_id" AS "Match_id",
        b."over_id",
        SUM(COALESCE(bs."runs_scored", 0) + COALESCE(er."extra_runs", 0)) AS "Runs_conceded_in_over"
    FROM IPL.IPL."BALL_BY_BALL" b
    LEFT JOIN IPL.IPL."BATSMAN_SCORED" bs ON b."match_id" = bs."match_id"
                                           AND b."innings_no" = bs."innings_no"
                                           AND b."over_id" = bs."over_id"
                                           AND b."ball_id" = bs."ball_id"
    LEFT JOIN IPL.IPL."EXTRA_RUNS" er ON b."match_id" = er."match_id"
                                       AND b."innings_no" = er."innings_no"
                                       AND b."over_id" = er."over_id"
                                       AND b."ball_id" = er."ball_id"
    JOIN IPL.IPL."PLAYER" p ON b."bowler" = p."player_id"
    GROUP BY p."player_name", b."match_id", b."over_id"
) t
ORDER BY t."Runs_conceded_in_over" DESC NULLS LAST
LIMIT 3;