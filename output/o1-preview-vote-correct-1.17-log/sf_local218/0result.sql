SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "highest_season_goals") AS "median_highest_season_goals"
FROM (
    SELECT
        "team_api_id",
        MAX("season_total_goals") AS "highest_season_goals"
    FROM (
        SELECT
            "team_api_id",
            "season",
            SUM("goals") AS "season_total_goals"
        FROM (
            SELECT
                "season",
                "home_team_api_id" AS "team_api_id",
                "home_team_goal" AS "goals"
            FROM EU_SOCCER.EU_SOCCER."MATCH"
            WHERE "home_team_goal" IS NOT NULL

            UNION ALL

            SELECT
                "season",
                "away_team_api_id" AS "team_api_id",
                "away_team_goal" AS "goals"
            FROM EU_SOCCER.EU_SOCCER."MATCH"
            WHERE "away_team_goal" IS NOT NULL
        ) AS "team_goals"
        GROUP BY "team_api_id", "season"
    ) AS "season_totals"
    GROUP BY "team_api_id"
) AS "highest_goals_per_team";