SELECT m."country_name",
       ROUND((SUM(a."population") / m."midyear_population") * 100, 4) AS "percentage_under_25"
FROM "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION_AGESPECIFIC" a
JOIN "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION" m
  ON a."country_code" = m."country_code" AND a."year" = m."year"
WHERE a."year" = 2017 AND a."age" < 25
GROUP BY m."country_name", m."midyear_population"
ORDER BY "percentage_under_25" DESC NULLS LAST
LIMIT 1;