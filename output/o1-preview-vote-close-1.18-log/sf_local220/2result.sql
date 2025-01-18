WITH match_results AS (
    SELECT
        "id" AS match_id,
        "home_team_api_id",
        "away_team_api_id",
        CASE
            WHEN "home_team_goal" > "away_team_goal" THEN "home_team_api_id"
            WHEN "home_team_goal" < "away_team_goal" THEN "away_team_api_id"
            ELSE NULL
        END AS winning_team_api_id
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
),
player_matches AS (
    SELECT m."id" AS match_id, m."home_team_api_id" AS team_api_id, m."home_player_1" AS player_api_id
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_2"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_3"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_4"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_5"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_6"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_7"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_8"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_9"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_10"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."home_team_api_id", m."home_player_11"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_1"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_2"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_3"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_4"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_5"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_6"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_7"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_8"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_9"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_10"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
    UNION ALL
    SELECT m."id", m."away_team_api_id", m."away_player_11"
    FROM "EU_SOCCER"."EU_SOCCER"."MATCH" m
),
player_wins AS (
    SELECT
        pm.player_api_id,
        CASE
            WHEN pm.team_api_id = mr.winning_team_api_id THEN 1
            ELSE 0
        END AS win
    FROM player_matches pm
    JOIN match_results mr ON pm.match_id = mr.match_id
    WHERE pm.player_api_id IS NOT NULL
),
player_win_counts AS (
    SELECT
        player_api_id,
        SUM(win) AS total_wins
    FROM player_wins
    GROUP BY player_api_id
)
SELECT
    p."player_name" AS "Player Name",
    pwc.total_wins AS "Total Wins"
FROM player_win_counts pwc
JOIN "EU_SOCCER"."EU_SOCCER"."PLAYER" p
    ON pwc.player_api_id = p."player_api_id"
ORDER BY pwc.total_wins DESC NULLS LAST
LIMIT 1;