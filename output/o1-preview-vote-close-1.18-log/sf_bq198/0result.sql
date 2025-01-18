WITH MaxWinsPerSeason AS (
    SELECT "season", MAX("wins") AS "max_wins"
    FROM NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_HISTORICAL_TEAMS_SEASONS
    WHERE "season" BETWEEN 1900 AND 2000
    GROUP BY "season"
),
MaxWinsTeams AS (
    SELECT HTS."team_id", HTS."market", HTS."name", HTS."season", HTS."wins"
    FROM NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_HISTORICAL_TEAMS_SEASONS HTS
    INNER JOIN MaxWinsPerSeason MWS
        ON HTS."season" = MWS."season" AND HTS."wins" = MWS."max_wins"
    WHERE HTS."season" BETWEEN 1900 AND 2000
)
SELECT
    MWT."market" AS "team_market",
    MWT."name" AS "team_name",
    COUNT(*) AS "num_max_win_seasons"
FROM MaxWinsTeams MWT
GROUP BY MWT."team_id", MWT."market", MWT."name"
ORDER BY "num_max_win_seasons" DESC NULLS LAST
LIMIT 5;