WITH home_wins AS (
    SELECT
        "home_player_1",
        "home_player_2",
        "home_player_3",
        "home_player_4",
        "home_player_5",
        "home_player_6",
        "home_player_7",
        "home_player_8",
        "home_player_9",
        "home_player_10",
        "home_player_11"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
    WHERE "home_team_goal" > "away_team_goal"
),
away_wins AS (
    SELECT
        "away_player_1",
        "away_player_2",
        "away_player_3",
        "away_player_4",
        "away_player_5",
        "away_player_6",
        "away_player_7",
        "away_player_8",
        "away_player_9",
        "away_player_10",
        "away_player_11"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
    WHERE "away_team_goal" > "home_team_goal"
),
all_winning_players AS (
    SELECT "home_player_1" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_2" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_3" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_4" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_5" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_6" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_7" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_8" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_9" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_10" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "home_player_11" AS "player_api_id" FROM home_wins UNION ALL
    SELECT "away_player_1" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_2" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_3" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_4" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_5" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_6" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_7" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_8" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_9" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_10" AS "player_api_id" FROM away_wins UNION ALL
    SELECT "away_player_11" AS "player_api_id" FROM away_wins
)
SELECT
    P."player_name" AS "Player_Name",
    COUNT(*) AS "Number_of_Wins"
FROM
    all_winning_players W
JOIN "EU_SOCCER"."EU_SOCCER"."PLAYER" P
    ON W."player_api_id" = P."player_api_id"
WHERE W."player_api_id" IS NOT NULL
GROUP BY
    P."player_name"
ORDER BY
    "Number_of_Wins" DESC NULLS LAST
LIMIT 1;