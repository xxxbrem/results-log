SELECT
  "name" AS "Team_Name",
  COUNT(*) AS "Number_of_Times_Max_Wins"
FROM (
  SELECT
    "season",
    "team_id",
    "name",
    "wins",
    MAX("wins") OVER (PARTITION BY "season") AS "season_max_wins"
  FROM NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_HISTORICAL_TEAMS_SEASONS
  WHERE "season" BETWEEN 1900 AND 2000
    AND "wins" IS NOT NULL
) sub
WHERE "wins" = "season_max_wins"
  AND "name" IS NOT NULL
  AND "name" <> ''
GROUP BY "name"
ORDER BY "Number_of_Times_Max_Wins" DESC NULLS LAST
LIMIT 5;