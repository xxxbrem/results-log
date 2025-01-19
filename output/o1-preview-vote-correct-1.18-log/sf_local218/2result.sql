WITH team_goals_per_season AS (
  SELECT
    "team_api_id",
    "season",
    SUM("goals") AS "total_goals"
  FROM (
    SELECT "home_team_api_id" AS "team_api_id", "season", "home_team_goal" AS "goals"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
    UNION ALL
    SELECT "away_team_api_id" AS "team_api_id", "season", "away_team_goal" AS "goals"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
  ) AS team_goals
  GROUP BY "team_api_id", "season"
),
highest_goals_per_team AS (
  SELECT "team_api_id", MAX("total_goals") AS "highest_season_goals"
  FROM team_goals_per_season
  GROUP BY "team_api_id"
)
SELECT ROUND(MEDIAN("highest_season_goals"), 4) AS "MedianHighestSeasonGoals"
FROM highest_goals_per_team;