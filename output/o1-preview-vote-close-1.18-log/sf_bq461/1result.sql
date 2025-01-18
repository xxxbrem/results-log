WITH scoring_events AS (
    SELECT
        P."game_id",
        P."period",
        P."game_clock",
        P."team_market" AS "ScoringTeam",
        P."points_scored",
        P."event_description",
        TRY_TO_NUMBER(SPLIT_PART(P."game_clock", ':', 1)) * 60 + TRY_TO_NUMBER(SPLIT_PART(P."game_clock", ':', 2)) AS "seconds_remaining_in_period"
    FROM
        "NCAA_BASKETBALL"."NCAA_BASKETBALL"."MBB_PBP_SR" P
    WHERE
        P."season" = 2014
        AND P."points_scored" > 0
        AND P."team_market" IN ('Notre Dame', 'Kentucky')
        AND P."game_id" IN (
            SELECT
                "game_id"
            FROM
                "NCAA_BASKETBALL"."NCAA_BASKETBALL"."MBB_PBP_SR"
            WHERE
                "season" = 2014
                AND "team_market" = 'Notre Dame'
            INTERSECT
            SELECT
                "game_id"
            FROM
                "NCAA_BASKETBALL"."NCAA_BASKETBALL"."MBB_PBP_SR"
            WHERE
                "season" = 2014
                AND "team_market" = 'Kentucky'
        )
),
ordered_events AS (
    SELECT
        scoring_events.*,
        (("period" - 1) * 1200) + (1200 - "seconds_remaining_in_period") AS "seconds_elapsed"
    FROM
        scoring_events
),
events_with_scores AS (
    SELECT
        ordered_events.*,
        ROUND(SUM("points_scored") OVER (
            PARTITION BY "ScoringTeam"
            ORDER BY "seconds_elapsed"
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 4) AS "TeamScore"
    FROM
        ordered_events
)
SELECT
    "period" AS "Period",
    "game_clock" AS "GameClock",
    "TeamScore",
    "ScoringTeam",
    "event_description" AS "EventDescription"
FROM
    events_with_scores
ORDER BY
    "seconds_elapsed" ASC;