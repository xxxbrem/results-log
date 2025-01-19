SELECT t."team_long_name" AS "Team_Name", COUNT(*) AS "Number_of_Wins"
FROM (
    SELECT "home_team_api_id" AS "team_id"
    FROM "Match"
    WHERE "home_team_goal" > "away_team_goal"
    UNION ALL
    SELECT "away_team_api_id" AS "team_id"
    FROM "Match"
    WHERE "away_team_goal" > "home_team_goal"
) AS w
JOIN "Team" t ON w."team_id" = t."team_api_id"
GROUP BY t."team_long_name"
ORDER BY "Number_of_Wins" DESC
LIMIT 10;