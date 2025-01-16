SELECT p."country_name", ROUND((u."population_under_25" / p."midyear_population") * 100, 4) AS "Percentage_Under_25"
FROM CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION" p
JOIN (
  SELECT "country_code", SUM("population") AS "population_under_25"
  FROM CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION_AGESPECIFIC"
  WHERE "year" = 2017 AND "age" < 25
  GROUP BY "country_code"
) u ON p."country_code" = u."country_code"
WHERE p."year" = 2017
ORDER BY "Percentage_Under_25" DESC NULLS LAST
LIMIT 1;