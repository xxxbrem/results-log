WITH teams_per_league AS (
    SELECT DISTINCT "league_id", "home_team_api_id" AS "team_api_id"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
    UNION
    SELECT DISTINCT "league_id", "away_team_api_id" AS "team_api_id"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
),
wins_per_team_league AS (
    SELECT "league_id", "winning_team_api_id" AS "team_api_id", COUNT(*) AS "wins"
    FROM (
        SELECT "id", "league_id",
            "home_team_api_id",
            "away_team_api_id",
            "home_team_goal",
            "away_team_goal",
            CASE
                WHEN "home_team_goal" > "away_team_goal" THEN "home_team_api_id"
                WHEN "home_team_goal" < "away_team_goal" THEN "away_team_api_id"
                ELSE NULL
            END AS "winning_team_api_id"
        FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
    ) AS match_results
    WHERE "winning_team_api_id" IS NOT NULL
    GROUP BY "league_id", "winning_team_api_id"
),
league_team_wins AS (
    SELECT t."league_id", t."team_api_id", COALESCE(w."wins", 0) AS "wins"
    FROM teams_per_league t
    LEFT JOIN wins_per_team_league w
    ON t."league_id" = w."league_id" AND t."team_api_id" = w."team_api_id"
),
ranked_teams AS (
    SELECT
        league_team_wins."league_id",
        league_team_wins."team_api_id",
        league_team_wins."wins",
        ROW_NUMBER() OVER (
            PARTITION BY league_team_wins."league_id"
            ORDER BY league_team_wins."wins" ASC, league_team_wins."team_api_id" ASC
        ) AS "rn"
    FROM league_team_wins
)
SELECT l."name" AS "League_Name",
       tm."team_long_name" AS "Team_Name",
       rt."wins" AS "Number_of_Wins"
FROM ranked_teams rt
JOIN "EU_SOCCER"."EU_SOCCER"."LEAGUE" l ON rt."league_id" = l."id"
JOIN "EU_SOCCER"."EU_SOCCER"."TEAM" tm ON rt."team_api_id" = tm."team_api_id"
WHERE rt."rn" = 1
ORDER BY l."name";