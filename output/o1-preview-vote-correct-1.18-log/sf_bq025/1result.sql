SELECT
  sub."country_name" AS "Country",
  SUM(sub."Population_Under_20") AS "Total_Population_Under_20",
  mp."midyear_population" AS "Total_Midyear_Population",
  ROUND((SUM(sub."Population_Under_20") / mp."midyear_population") * 100, 4) AS "Percentage_Under_20"
FROM (
  SELECT
    t."country_code",
    t."country_name",
    t."sex",
    SUM(
      COALESCE(t."population_age_0", 0) + COALESCE(t."population_age_1", 0) + COALESCE(t."population_age_2", 0) +
      COALESCE(t."population_age_3", 0) + COALESCE(t."population_age_4", 0) + COALESCE(t."population_age_5", 0) +
      COALESCE(t."population_age_6", 0) + COALESCE(t."population_age_7", 0) + COALESCE(t."population_age_8", 0) +
      COALESCE(t."population_age_9", 0) + COALESCE(t."population_age_10", 0) + COALESCE(t."population_age_11", 0) +
      COALESCE(t."population_age_12", 0) + COALESCE(t."population_age_13", 0) + COALESCE(t."population_age_14", 0) +
      COALESCE(t."population_age_15", 0) + COALESCE(t."population_age_16", 0) + COALESCE(t."population_age_17", 0) +
      COALESCE(t."population_age_18", 0) + COALESCE(t."population_age_19", 0)
    ) AS "Population_Under_20"
  FROM "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION_AGE_SEX" t
  WHERE t."year" = 2020
  GROUP BY t."country_code", t."country_name", t."sex"
) sub
JOIN "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION" mp
  ON sub."country_code" = mp."country_code" AND mp."year" = 2020
GROUP BY sub."country_name", mp."midyear_population"
ORDER BY "Percentage_Under_20" DESC NULLS LAST
LIMIT 10;