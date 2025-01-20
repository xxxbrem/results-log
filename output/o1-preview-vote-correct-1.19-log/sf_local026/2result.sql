SELECT
    p."player_name" AS bowler_name,
    bbb."match_id",
    bbb."over_id",
    SUM(COALESCE(bat."runs_scored", 0) + COALESCE(extra."extra_runs", 0)) AS total_runs_conceded
FROM
    "IPL"."IPL"."BALL_BY_BALL" AS bbb
LEFT JOIN "IPL"."IPL"."BATSMAN_SCORED" AS bat
    ON bbb."match_id" = bat."match_id"
    AND bbb."over_id" = bat."over_id"
    AND bbb."ball_id" = bat."ball_id"
    AND bbb."innings_no" = bat."innings_no"
LEFT JOIN "IPL"."IPL"."EXTRA_RUNS" AS extra
    ON bbb."match_id" = extra."match_id"
    AND bbb."over_id" = extra."over_id"
    AND bbb."ball_id" = extra."ball_id"
    AND bbb."innings_no" = extra."innings_no"
JOIN "IPL"."IPL"."PLAYER" AS p
    ON bbb."bowler" = p."player_id"
GROUP BY
    p."player_name",
    bbb."match_id",
    bbb."over_id"
ORDER BY
    total_runs_conceded DESC NULLS LAST
LIMIT 3;