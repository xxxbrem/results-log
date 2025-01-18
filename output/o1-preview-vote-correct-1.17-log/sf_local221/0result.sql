SELECT T."team_long_name" AS "team_name", total_wins
FROM (
    SELECT team_api_id, SUM(wins) AS total_wins
    FROM (
        SELECT "home_team_api_id" AS team_api_id, COUNT(*) AS wins
        FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
        WHERE "home_team_goal" > "away_team_goal"
        GROUP BY "home_team_api_id"
        UNION ALL
        SELECT "away_team_api_id" AS team_api_id, COUNT(*) AS wins
        FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
        WHERE "away_team_goal" > "home_team_goal"
        GROUP BY "away_team_api_id"
    ) AS sub
    GROUP BY team_api_id
) AS total_wins_per_team
JOIN "EU_SOCCER"."EU_SOCCER"."TEAM" AS T ON total_wins_per_team.team_api_id = T."team_api_id"
ORDER BY total_wins DESC NULLS LAST
LIMIT 10;