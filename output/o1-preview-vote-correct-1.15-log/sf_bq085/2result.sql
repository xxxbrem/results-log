WITH cases AS (
  SELECT
    CASE
      WHEN "country_region" = 'US' THEN 'United States'
      ELSE "country_region"
    END AS "country",
    SUM("confirmed") AS "total_confirmed_cases"
  FROM "COVID19_JHU_WORLD_BANK"."COVID19_JHU_CSSE"."SUMMARY"
  WHERE "date" = '2020-04-20' AND "country_region" IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
  GROUP BY "country_region"
),
population AS (
  SELECT
    CASE
      WHEN "country_name" = 'Iran, Islamic Rep.' THEN 'Iran'
      ELSE "country_name"
    END AS "country",
    "value" AS "population_2020"
  FROM "COVID19_JHU_WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA"
  WHERE "indicator_code" = 'SP.POP.TOTL' AND "year" = 2020 AND "country_name" IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
)
SELECT
  c."country",
  c."total_confirmed_cases",
  ROUND((c."total_confirmed_cases" / p."population_2020") * 100000, 4) AS "cases_per_100000"
FROM cases c
JOIN population p ON c."country" = p."country";