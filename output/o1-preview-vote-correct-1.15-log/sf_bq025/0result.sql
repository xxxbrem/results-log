SELECT 
    pu."country_name",
    pu.total_population_under_20,
    tp."midyear_population" AS total_midyear_population,
    ROUND((pu.total_population_under_20 / tp."midyear_population") * 100, 4) AS percentage_population_under_20
FROM
    (
        SELECT
            "country_code",
            "country_name",
            SUM("population") AS total_population_under_20
        FROM
            CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION_AGESPECIFIC"
        WHERE
            "year" = 2020
            AND "age" < 20
        GROUP BY
            "country_code", "country_name"
    ) pu
JOIN
    (
        SELECT
            "country_code",
            "midyear_population"
        FROM
            CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."MIDYEAR_POPULATION"
        WHERE
            "year" = 2020
    ) tp
ON
    pu."country_code" = tp."country_code"
ORDER BY
    percentage_population_under_20 DESC NULLS LAST
LIMIT 10;