WITH "Winning_Matches" AS (
    SELECT
        M."match_api_id",
        M."home_team_api_id" AS "winner_team_api_id",
        'home' AS "winner_side",
        M."home_player_1" AS "player1",
        M."home_player_2" AS "player2",
        M."home_player_3" AS "player3",
        M."home_player_4" AS "player4",
        M."home_player_5" AS "player5",
        M."home_player_6" AS "player6",
        M."home_player_7" AS "player7",
        M."home_player_8" AS "player8",
        M."home_player_9" AS "player9",
        M."home_player_10" AS "player10",
        M."home_player_11" AS "player11"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" M
    WHERE M."home_team_goal" > M."away_team_goal"

    UNION ALL

    SELECT
        M."match_api_id",
        M."away_team_api_id" AS "winner_team_api_id",
        'away' AS "winner_side",
        M."away_player_1" AS "player1",
        M."away_player_2" AS "player2",
        M."away_player_3" AS "player3",
        M."away_player_4" AS "player4",
        M."away_player_5" AS "player5",
        M."away_player_6" AS "player6",
        M."away_player_7" AS "player7",
        M."away_player_8" AS "player8",
        M."away_player_9" AS "player9",
        M."away_player_10" AS "player10",
        M."away_player_11" AS "player11"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" M
    WHERE M."away_team_goal" > M."home_team_goal"
)
SELECT
    P."player_name" AS "Player_Name",
    COUNT(*) AS "Wins"
FROM
    "Winning_Matches" WM
    UNPIVOT( "player_api_id" FOR "player_col" IN (
        "player1", "player2", "player3", "player4", "player5", "player6", "player7", "player8", "player9", "player10", "player11" )
    ) AS UNPVT
    JOIN "EU_SOCCER"."EU_SOCCER"."PLAYER" P ON P."player_api_id" = UNPVT."player_api_id"
WHERE
    UNPVT."player_api_id" IS NOT NULL
GROUP BY
    P."player_api_id",
    P."player_name"
ORDER BY
    "Wins" DESC NULLS LAST
LIMIT 1;