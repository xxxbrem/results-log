WITH team_wins AS (
    SELECT
        m."league_id",
        CASE
            WHEN m."home_team_goal" > m."away_team_goal" THEN m."home_team_api_id"
            WHEN m."home_team_goal" < m."away_team_goal" THEN m."away_team_api_id"
            ELSE NULL
        END AS "winner_team_id"
    FROM EU_SOCCER.EU_SOCCER."MATCH" m
),
wins_per_team AS (
    SELECT
        "league_id",
        "winner_team_id",
        COUNT(*) AS "wins"
    FROM team_wins
    WHERE "winner_team_id" IS NOT NULL
    GROUP BY "league_id", "winner_team_id"
),
min_wins_per_league AS (
    SELECT
        "league_id",
        MIN("wins") AS "min_wins"
    FROM wins_per_team
    GROUP BY "league_id"
),
ranked_teams AS (
    SELECT
        wpt.*,
        ROW_NUMBER() OVER (
            PARTITION BY wpt."league_id" 
            ORDER BY wpt."wins", wpt."winner_team_id"
        ) AS rn
    FROM wins_per_team wpt
    JOIN min_wins_per_league mwpl
        ON wpt."league_id" = mwpl."league_id" 
        AND wpt."wins" = mwpl."min_wins"
)
SELECT
    l."name" AS "League_name",
    t."team_long_name" AS "Team_name"
FROM ranked_teams rt
JOIN EU_SOCCER.EU_SOCCER.TEAM t ON t."team_api_id" = rt."winner_team_id"
JOIN EU_SOCCER.EU_SOCCER.LEAGUE l ON l."id" = rt."league_id"
WHERE rt.rn = 1;