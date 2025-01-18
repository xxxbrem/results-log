SELECT
    p."player_name" AS "Bowler_Name",
    bb."match_id" AS "Match_ID",
    SUM(
        COALESCE(bs."runs_scored", 0) + COALESCE(er."extra_runs", 0)
    ) AS "Runs_Conceded"
FROM
    "IPL"."IPL"."BALL_BY_BALL" bb
LEFT JOIN
    "IPL"."IPL"."BATSMAN_SCORED" bs
    ON
        bb."match_id" = bs."match_id" AND
        bb."over_id" = bs."over_id" AND
        bb."ball_id" = bs."ball_id" AND
        bb."innings_no" = bs."innings_no"
LEFT JOIN
    "IPL"."IPL"."EXTRA_RUNS" er
    ON
        bb."match_id" = er."match_id" AND
        bb."over_id" = er."over_id" AND
        bb."ball_id" = er."ball_id" AND
        bb."innings_no" = er."innings_no"
INNER JOIN
    "IPL"."IPL"."PLAYER" p
    ON
        bb."bowler" = p."player_id"
GROUP BY
    bb."bowler",
    p."player_name",
    bb."match_id",
    bb."over_id"
ORDER BY
    "Runs_Conceded" DESC,
    bb."match_id" ASC,
    p."player_name" ASC
LIMIT 3;