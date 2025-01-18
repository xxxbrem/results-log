SELECT t."team_long_name" AS "team_name", w."total_wins"
FROM EU_SOCCER.EU_SOCCER."TEAM" t
JOIN (
  SELECT "team_api_id", SUM("wins") AS "total_wins"
  FROM (
    SELECT "home_team_api_id" AS "team_api_id", COUNT(*) AS "wins"
    FROM EU_SOCCER.EU_SOCCER."MATCH"
    WHERE "home_team_goal" > "away_team_goal"
    GROUP BY "home_team_api_id"
    UNION ALL
    SELECT "away_team_api_id" AS "team_api_id", COUNT(*) AS "wins"
    FROM EU_SOCCER.EU_SOCCER."MATCH"
    WHERE "away_team_goal" > "home_team_goal"
    GROUP BY "away_team_api_id"
  ) AS "wins_table"
  GROUP BY "team_api_id"
) w ON t."team_api_id" = w."team_api_id"
ORDER BY w."total_wins" DESC NULLS LAST
LIMIT 10;