WITH season5_matches AS (
    SELECT "match_id"
    FROM "IPL"."IPL"."MATCH"
    WHERE "season_id" = 5
),
player_runs AS (
    SELECT BBS."striker" AS "player_id", SUM(BS."runs_scored") AS "total_runs"
    FROM "IPL"."IPL"."BATSMAN_SCORED" BS
    JOIN "IPL"."IPL"."BALL_BY_BALL" BBS ON
        BS."match_id" = BBS."match_id" AND
        BS."over_id" = BBS."over_id" AND
        BS."ball_id" = BBS."ball_id" AND
        BS."innings_no" = BBS."innings_no"
    WHERE BS."match_id" IN (SELECT "match_id" FROM season5_matches)
    GROUP BY BBS."striker"
),
player_dismissals AS (
    SELECT WT."player_out" AS "player_id", COUNT(*) AS "times_out"
    FROM "IPL"."IPL"."WICKET_TAKEN" WT
    WHERE WT."match_id" IN (SELECT "match_id" FROM season5_matches)
    GROUP BY WT."player_out"
),
player_matches AS (
    SELECT PM."player_id", COUNT(DISTINCT PM."match_id") AS "matches_played"
    FROM "IPL"."IPL"."PLAYER_MATCH" PM
    WHERE PM."match_id" IN (SELECT "match_id" FROM season5_matches)
    GROUP BY PM."player_id"
),
player_stats AS (
    SELECT
        PR."player_id",
        PR."total_runs",
        COALESCE(PD."times_out", 0) AS "times_out",
        PM."matches_played"
    FROM player_runs PR
    LEFT JOIN player_dismissals PD ON PR."player_id" = PD."player_id"
    LEFT JOIN player_matches PM ON PR."player_id" = PM."player_id"
),
player_averages AS (
    SELECT
        PS."player_id",
        ROUND(PS."total_runs"::NUMERIC / PS."matches_played", 4) AS "average_runs_per_match",
        ROUND(PS."total_runs"::NUMERIC / NULLIF(PS."times_out", 0), 4) AS "batting_average"
    FROM player_stats PS
),
top5_players AS (
    SELECT
        PA."player_id",
        PA."average_runs_per_match",
        PA."batting_average"
    FROM player_averages PA
    ORDER BY PA."average_runs_per_match" DESC NULLS LAST
    LIMIT 5
)
SELECT
    P."player_name",
    T5."average_runs_per_match",
    T5."batting_average"
FROM top5_players T5
JOIN "IPL"."IPL"."PLAYER" P ON T5."player_id" = P."player_id"
ORDER BY T5."average_runs_per_match" DESC NULLS LAST;