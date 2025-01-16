SELECT t1."country_name", 
       ROUND((t1."population_under_25" / t2."midyear_population") * 100, 4) AS "percentage_under25"
FROM (
    SELECT "country_name", SUM("population") AS "population_under_25"
    FROM CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION_AGESPECIFIC"
    WHERE "year" = 2017 AND "age" < 25
    GROUP BY "country_name"
) t1
JOIN CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION" t2
ON t1."country_name" = t2."country_name" AND t2."year" = 2017
ORDER BY "percentage_under25" DESC NULLS LAST
LIMIT 1;