WITH total_goals_per_team_per_season AS (
    SELECT
        team_api_id,
        season,
        SUM(goals) AS total_goals
    FROM
        (
            SELECT
                home_team_api_id AS team_api_id,
                season,
                SUM(home_team_goal) AS goals
            FROM
                "Match"
            GROUP BY
                home_team_api_id,
                season
            UNION ALL
            SELECT
                away_team_api_id AS team_api_id,
                season,
                SUM(away_team_goal) AS goals
            FROM
                "Match"
            GROUP BY
                away_team_api_id,
                season
        )
    GROUP BY
        team_api_id,
        season
),
highest_season_goals_per_team AS (
    SELECT
        team_api_id,
        MAX(total_goals) AS highest_season_goals
    FROM
        total_goals_per_team_per_season
    GROUP BY
        team_api_id
)
SELECT ROUND(AVG(highest_season_goals), 4) AS median_highest_season_goals
FROM
(
    SELECT highest_season_goals
    FROM highest_season_goals_per_team
    ORDER BY highest_season_goals
    LIMIT 2 - ( (SELECT COUNT(*) FROM highest_season_goals_per_team) % 2 )
    OFFSET ( (SELECT (COUNT(*) - 1) / 2 FROM highest_season_goals_per_team) )
)