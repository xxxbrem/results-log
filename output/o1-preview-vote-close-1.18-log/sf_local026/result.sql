SELECT
    p."player_name" AS "Bowler Name",
    runs_over."match_id" AS "Match ID",
    runs_over."runs_conceded" AS "Runs Conceded"
FROM
    (
        SELECT
            bb."match_id",
            bb."bowler",
            bb."over_id",
            SUM(COALESCE(bs."runs_scored", 0) + COALESCE(er."extra_runs", 0)) AS "runs_conceded"
        FROM
            IPL.IPL.BALL_BY_BALL bb
            LEFT JOIN IPL.IPL.BATSMAN_SCORED bs
                ON bb."match_id" = bs."match_id"
                AND bb."over_id" = bs."over_id"
                AND bb."ball_id" = bs."ball_id"
                AND bb."innings_no" = bs."innings_no"
            LEFT JOIN IPL.IPL.EXTRA_RUNS er
                ON bb."match_id" = er."match_id"
                AND bb."over_id" = er."over_id"
                AND bb."ball_id" = er."ball_id"
                AND bb."innings_no" = er."innings_no"
        GROUP BY
            bb."match_id",
            bb."bowler",
            bb."over_id"
    ) runs_over
    INNER JOIN IPL.IPL.PLAYER p
        ON runs_over."bowler" = p."player_id"
ORDER BY
    runs_over."runs_conceded" DESC NULLS LAST
LIMIT 3;