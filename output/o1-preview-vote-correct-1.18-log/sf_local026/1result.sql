WITH BallData AS (
    SELECT
        B."match_id",
        B."over_id",
        B."bowler",
        COALESCE(S."runs_scored", 0) AS "runs_off_bat",
        COALESCE(E."extra_runs", 0) AS "extra_runs"
    FROM
        IPL.IPL."BALL_BY_BALL" B
    LEFT JOIN IPL.IPL."BATSMAN_SCORED" S
        ON B."match_id" = S."match_id"
        AND B."over_id" = S."over_id"
        AND B."ball_id" = S."ball_id"
    LEFT JOIN IPL.IPL."EXTRA_RUNS" E
        ON B."match_id" = E."match_id"
        AND B."over_id" = E."over_id"
        AND B."ball_id" = E."ball_id"
),
OverRuns AS (
    SELECT
        "match_id",
        "over_id",
        "bowler",
        SUM("runs_off_bat" + "extra_runs") AS "total_runs_conceded"
    FROM
        BallData
    GROUP BY
        "match_id",
        "over_id",
        "bowler"
),
TopOvers AS (
    SELECT
        O."bowler",
        O."match_id",
        O."total_runs_conceded"
    FROM
        OverRuns O
    ORDER BY
        O."total_runs_conceded" DESC NULLS LAST
    LIMIT 3
)
SELECT
    P."player_name" AS "bowler_name",
    T."match_id",
    T."total_runs_conceded" AS "max_runs_conceded"
FROM
    TopOvers T
INNER JOIN
    IPL.IPL."PLAYER" P
    ON T."bowler" = P."player_id";