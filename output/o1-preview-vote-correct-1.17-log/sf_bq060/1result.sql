SELECT "cna"."country_name", ROUND("bdgr"."net_migration", 4) AS "net_migration_rate"
FROM "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."BIRTH_DEATH_GROWTH_RATES" AS "bdgr"
JOIN "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."COUNTRY_NAMES_AREA" AS "cna"
ON "bdgr"."country_code" = "cna"."country_code"
WHERE "bdgr"."year" = 2017
  AND "cna"."country_area" > 500
ORDER BY "net_migration_rate" DESC NULLS LAST
LIMIT 3;