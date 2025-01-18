WITH total_goals_per_team_season AS (
  SELECT "season", "team_api_id", SUM("goals") AS "season_goals"
  FROM (
    SELECT "season", "home_team_api_id" AS "team_api_id", "home_team_goal" AS "goals"
    FROM EU_SOCCER.EU_SOCCER.MATCH
    UNION ALL
    SELECT "season", "away_team_api_id" AS "team_api_id", "away_team_goal" AS "goals"
    FROM EU_SOCCER.EU_SOCCER.MATCH
  ) AS "team_goals"
  GROUP BY "season", "team_api_id"
),
highest_season_goals_per_team AS (
  SELECT "team_api_id", MAX("season_goals") AS "highest_season_goals"
  FROM total_goals_per_team_season
  GROUP BY "team_api_id"
)
SELECT ROUND(MEDIAN("highest_season_goals"), 4) AS "Median_Highest_Season_Goals"
FROM highest_season_goals_per_team;