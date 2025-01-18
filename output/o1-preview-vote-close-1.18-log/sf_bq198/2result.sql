SELECT
    "name" AS "Team_Name",
    COUNT(*) AS "Number_of_Times_Max_Wins"
FROM
    (
        SELECT
            ht."team_id",
            ht."name",
            ht."season",
            ht."wins"
        FROM
            NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_HISTORICAL_TEAMS_SEASONS ht
            INNER JOIN (
                SELECT
                    "season",
                    MAX("wins") AS "max_wins"
                FROM
                    NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_HISTORICAL_TEAMS_SEASONS
                WHERE
                    "season" BETWEEN 1900 AND 2000
                GROUP BY
                    "season"
            ) mw ON ht."season" = mw."season" AND ht."wins" = mw."max_wins"
        WHERE
            ht."season" BETWEEN 1900 AND 2000
    ) max_win_teams
GROUP BY
    "Team_Name"
ORDER BY
    "Number_of_Times_Max_Wins" DESC NULLS LAST
LIMIT 5;