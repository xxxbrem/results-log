SELECT
    t4."player_name" AS "Bowler",
    t1."match_id" AS "Match_ID",
    SUM(COALESCE(t2."runs_scored", 0) + COALESCE(t3."extra_runs", 0)) AS "Runs_Conceded"
FROM
    IPL.IPL."BALL_BY_BALL" t1
LEFT JOIN
    IPL.IPL."BATSMAN_SCORED" t2
    ON t1."match_id" = t2."match_id" 
    AND t1."innings_no" = t2."innings_no"
    AND t1."over_id" = t2."over_id" 
    AND t1."ball_id" = t2."ball_id" 
LEFT JOIN
    IPL.IPL."EXTRA_RUNS" t3
    ON t1."match_id" = t3."match_id" 
    AND t1."innings_no" = t3."innings_no"
    AND t1."over_id" = t3."over_id" 
    AND t1."ball_id" = t3."ball_id" 
JOIN
    IPL.IPL."PLAYER" t4
    ON t1."bowler" = t4."player_id"
GROUP BY
    t4."player_name",
    t1."match_id",
    t1."innings_no",
    t1."over_id"
ORDER BY
    "Runs_Conceded" DESC NULLS LAST
LIMIT 3;