WITH Max_Wins_Per_Season AS (
    SELECT
        "season",
        MAX("wins") AS "max_wins"
    FROM NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_HISTORICAL_TEAMS_SEASONS
    WHERE "season" BETWEEN 1900 AND 2000
    GROUP BY "season"
),
Teams_With_Max_Wins AS (
    SELECT
        S."team_id",
        S."market",
        S."name" AS "Team_Name",
        S."season"
    FROM NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_HISTORICAL_TEAMS_SEASONS S
    INNER JOIN Max_Wins_Per_Season M
        ON S."season" = M."season" AND S."wins" = M."max_wins"
    WHERE S."season" BETWEEN 1900 AND 2000 AND S."team_id" IS NOT NULL
)
SELECT
    T."Team_Name",
    T."market",
    COUNT(*) AS "Max_Wins_Seasons"
FROM Teams_With_Max_Wins T
GROUP BY T."Team_Name", T."market"
ORDER BY "Max_Wins_Seasons" DESC NULLS LAST
LIMIT 5;