WITH cte_season_goals AS (
    SELECT
        team_id,
        "season",
        SUM(team_goals) AS total_goals
    FROM
        (
            SELECT
                "home_team_api_id" AS team_id,
                "season",
                "home_team_goal" AS team_goals
            FROM EU_SOCCER.EU_SOCCER."MATCH"
            UNION ALL
            SELECT
                "away_team_api_id" AS team_id,
                "season",
                "away_team_goal" AS team_goals
            FROM EU_SOCCER.EU_SOCCER."MATCH"
        ) AS all_goals
    GROUP BY team_id, "season"
),
cte_highest_season_goals AS (
    SELECT
        team_id,
        MAX(total_goals) AS highest_season_goals
    FROM cte_season_goals
    GROUP BY team_id
)
SELECT
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY highest_season_goals),
        4
    ) AS "Median_Highest_Season_Goals"
FROM
    cte_highest_season_goals;