SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "highest_goals") AS "median_highest_season_goals"
FROM (
    SELECT "team_id", MAX("total_goals") AS "highest_goals"
    FROM (
        SELECT
            "team_id",
            "season",
            SUM("goals_scored") AS "total_goals"
        FROM (
            SELECT "home_team_api_id" AS "team_id", "season", "home_team_goal" AS "goals_scored"
            FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
            WHERE "home_team_api_id" IS NOT NULL AND "home_team_goal" IS NOT NULL
            UNION ALL
            SELECT "away_team_api_id" AS "team_id", "season", "away_team_goal" AS "goals_scored"
            FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
            WHERE "away_team_api_id" IS NOT NULL AND "away_team_goal" IS NOT NULL
        ) AS "team_goals"
        GROUP BY "team_id", "season"
    ) AS "team_season_totals"
    GROUP BY "team_id"
) AS "highest_season_goals_per_team";