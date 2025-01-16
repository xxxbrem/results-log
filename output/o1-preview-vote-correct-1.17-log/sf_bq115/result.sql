SELECT
    a."country_name",
    ROUND((SUM(a."population") / b."midyear_population") * 100, 4) AS "percentage_under_25"
FROM
    CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION_AGESPECIFIC" a
JOIN
    CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION" b
ON
    a."country_code" = b."country_code" AND
    a."year" = b."year"
WHERE
    a."year" = 2017 AND
    a."age" < 25
GROUP BY
    a."country_name", b."midyear_population"
ORDER BY
    "percentage_under_25" DESC NULLS LAST
LIMIT 1;