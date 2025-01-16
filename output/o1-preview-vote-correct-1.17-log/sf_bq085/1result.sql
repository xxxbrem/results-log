WITH country_mapping AS (
    SELECT 'US' AS "country_region", 'United States' AS "country_name"
    UNION ALL
    SELECT 'France', 'France'
    UNION ALL
    SELECT 'China', 'China'
    UNION ALL
    SELECT 'Italy', 'Italy'
    UNION ALL
    SELECT 'Spain', 'Spain'
    UNION ALL
    SELECT 'Germany', 'Germany'
    UNION ALL
    SELECT 'Iran', 'Iran, Islamic Rep.'
),
covid_data AS (
    SELECT "country_region", SUM("confirmed") AS "total_confirmed_cases"
    FROM "COVID19_JHU_WORLD_BANK"."COVID19_JHU_CSSE"."SUMMARY"
    WHERE "date" = '2020-04-20'
      AND "country_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
    GROUP BY "country_region"
),
population_data AS (
    SELECT "country_name", "value" AS "population"
    FROM "COVID19_JHU_WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA"
    WHERE "indicator_name" = 'Population, total'
      AND "year" = 2020
      AND "country_name" IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
)
SELECT m."country_region" AS "country",
       c."total_confirmed_cases",
       ROUND((c."total_confirmed_cases" / p."population") * 100000, 4) AS "cases_per_100000"
FROM country_mapping m
JOIN covid_data c ON m."country_region" = c."country_region"
JOIN population_data p ON m."country_name" = p."country_name"
ORDER BY "country";