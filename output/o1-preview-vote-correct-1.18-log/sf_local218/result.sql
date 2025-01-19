WITH team_season_goals AS (
    SELECT
        "season",
        "team_api_id",
        SUM("goals_scored") AS "total_goals"
    FROM (
        SELECT
            "season",
            "home_team_api_id" AS "team_api_id",
            "home_team_goal" AS "goals_scored"
        FROM
            "EU_SOCCER"."EU_SOCCER"."MATCH"
        UNION ALL
        SELECT
            "season",
            "away_team_api_id" AS "team_api_id",
            "away_team_goal" AS "goals_scored"
        FROM
            "EU_SOCCER"."EU_SOCCER"."MATCH"
    ) AS all_goals
    GROUP BY
        "season",
        "team_api_id"
),
team_highest_goals AS (
    SELECT
        "team_api_id",
        MAX("total_goals") AS "highest_season_goals"
    FROM
        team_season_goals
    GROUP BY
        "team_api_id"
)
SELECT
    MEDIAN("highest_season_goals") AS "median_highest_season_goals"
FROM
    team_highest_goals;