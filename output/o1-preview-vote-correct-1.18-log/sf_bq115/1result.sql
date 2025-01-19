WITH total_pop_under25 AS (
    SELECT
        A."country_code",
        A."country_name",
        SUM(A."population") AS "pop_under25"
    FROM
        "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION_AGESPECIFIC" AS A
    WHERE
        A."year" = 2017 AND
        A."age" < 25
    GROUP BY
        A."country_code",
        A."country_name"
),
total_pop AS (
    SELECT
        B."country_code",
        B."country_name",
        B."midyear_population"
    FROM
        "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION" AS B
    WHERE
        B."year" = 2017
)

SELECT
    T."country_name" AS "Country Name",
    ROUND((T."pop_under25" / T2."midyear_population") * 100, 4) AS "Percentage Under Age 25"
FROM
    total_pop_under25 AS T
JOIN
    total_pop AS T2
    ON T."country_code" = T2."country_code"
ORDER BY
    "Percentage Under Age 25" DESC NULLS LAST
LIMIT 1;