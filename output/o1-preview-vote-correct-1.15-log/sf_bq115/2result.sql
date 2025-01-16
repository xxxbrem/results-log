SELECT
    under25."country_name",
    ROUND((under25."population_under_25" / total."midyear_population") * 100, 4) AS "percentage_under_25"
FROM
    (
        SELECT
            "country_name",
            SUM("population") AS "population_under_25"
        FROM
            "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION_AGESPECIFIC"
        WHERE
            "year" = 2017 AND "age" < 25
        GROUP BY
            "country_name"
    ) AS under25
JOIN
    (
        SELECT
            "country_name",
            "midyear_population"
        FROM
            "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION"
        WHERE
            "year" = 2017
    ) AS total
ON
    under25."country_name" = total."country_name"
ORDER BY
    "percentage_under_25" DESC NULLS LAST
LIMIT 1;