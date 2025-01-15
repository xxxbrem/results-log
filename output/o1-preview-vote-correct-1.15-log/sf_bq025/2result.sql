WITH population_under_20 AS (
    SELECT
        ma."country_code",
        ma."country_name",
        SUM(ma."population") AS "population_under_20"
    FROM
        "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION_AGESPECIFIC" ma
    WHERE
        ma."year" = 2020 AND ma."age" < 20
    GROUP BY
        ma."country_code",
        ma."country_name"
),
total_population AS (
    SELECT
        mp."country_code",
        mp."midyear_population" AS "total_population"
    FROM
        "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION" mp
    WHERE
        mp."year" = 2020
)
SELECT
    pu."country_name",
    pu."population_under_20",
    tp."total_population",
    ROUND((pu."population_under_20" / tp."total_population") * 100, 4) AS "percentage_under_20"
FROM
    population_under_20 pu
JOIN
    total_population tp
ON
    pu."country_code" = tp."country_code"
ORDER BY
    "percentage_under_20" DESC NULLS LAST
LIMIT 10;