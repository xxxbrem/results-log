SELECT
    under20."country_name",
    under20."total_population_under_20",
    total."midyear_population",
    ROUND((under20."total_population_under_20" / total."midyear_population") * 100, 4) AS "percentage_under_20"
FROM
    (
        SELECT
            "country_code",
            "country_name",
            SUM("population") AS "total_population_under_20"
        FROM
            CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL.MIDYEAR_POPULATION_AGESPECIFIC
        WHERE
            "year" = 2020
            AND "age" < 20
        GROUP BY
            "country_code",
            "country_name"
    ) AS under20
JOIN
    (
        SELECT
            "country_code",
            "midyear_population"
        FROM
            CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL.MIDYEAR_POPULATION
        WHERE
            "year" = 2020
            AND "midyear_population" IS NOT NULL
            AND "midyear_population" > 0
    ) AS total
ON
    under20."country_code" = total."country_code"
ORDER BY
    "percentage_under_20" DESC NULLS LAST
LIMIT 10;