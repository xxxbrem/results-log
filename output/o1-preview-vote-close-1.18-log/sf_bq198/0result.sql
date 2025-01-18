SELECT "name" AS "Team_Name", COUNT(*) AS "Times_Max_Wins"
FROM (
    SELECT s."season", s."name", s."wins"
    FROM NCAA_BASKETBALL.NCAA_BASKETBALL."MBB_HISTORICAL_TEAMS_SEASONS" s
    INNER JOIN (
        SELECT "season", MAX("wins") AS "max_wins"
        FROM NCAA_BASKETBALL.NCAA_BASKETBALL."MBB_HISTORICAL_TEAMS_SEASONS"
        WHERE "season" BETWEEN 1900 AND 2000
        GROUP BY "season"
    ) m ON s."season" = m."season" AND s."wins" = m."max_wins"
    WHERE s."season" BETWEEN 1900 AND 2000 AND s."name" IS NOT NULL AND s."name" <> ''
) t
GROUP BY "name"
ORDER BY "Times_Max_Wins" DESC NULLS LAST
LIMIT 5;