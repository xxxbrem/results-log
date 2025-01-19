SELECT t."team_long_name" AS "Team_Name",
       (COALESCE(hw."home_wins", 0) + COALESCE(aw."away_wins", 0)) AS "Number_of_Wins"
FROM EU_SOCCER.EU_SOCCER.TEAM t
LEFT JOIN (
    SELECT m."home_team_api_id", COUNT(*) AS "home_wins"
    FROM EU_SOCCER.EU_SOCCER.MATCH m
    WHERE m."home_team_goal" > m."away_team_goal"
    GROUP BY m."home_team_api_id"
) hw ON t."team_api_id" = hw."home_team_api_id"
LEFT JOIN (
    SELECT m."away_team_api_id", COUNT(*) AS "away_wins"
    FROM EU_SOCCER.EU_SOCCER.MATCH m
    WHERE m."away_team_goal" > m."home_team_goal"
    GROUP BY m."away_team_api_id"
) aw ON t."team_api_id" = aw."away_team_api_id"
ORDER BY "Number_of_Wins" DESC NULLS LAST
LIMIT 10;