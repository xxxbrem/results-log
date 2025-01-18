WITH max_wins_per_season AS (
    SELECT "season", MAX("wins") AS "max_wins"
    FROM "NCAA_BASKETBALL"."NCAA_BASKETBALL"."MBB_HISTORICAL_TEAMS_SEASONS"
    WHERE "season" BETWEEN 1900 AND 2000
    GROUP BY "season"
)
SELECT t."name" AS "Team_Name", COUNT(*) AS "Number_of_Seasons_with_Max_Wins"
FROM "NCAA_BASKETBALL"."NCAA_BASKETBALL"."MBB_HISTORICAL_TEAMS_SEASONS" t
JOIN max_wins_per_season m
  ON t."season" = m."season" AND t."wins" = m."max_wins"
WHERE t."name" IS NOT NULL AND t."name" <> ''
GROUP BY t."name"
ORDER BY "Number_of_Seasons_with_Max_Wins" DESC NULLS LAST
LIMIT 5;