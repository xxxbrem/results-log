SELECT
    "country_name",
    ROUND(
        (SUM(CASE WHEN "age" < 25 THEN "population" ELSE 0 END) / SUM("population")) * 100,
        4
    ) AS "percentage_under_25"
FROM
    "CENSUS_BUREAU_INTERNATIONAL"."CENSUS_BUREAU_INTERNATIONAL"."MIDYEAR_POPULATION_AGESPECIFIC"
WHERE
    "year" = 2017
GROUP BY
    "country_name"
ORDER BY
    "percentage_under_25" DESC NULLS LAST
LIMIT 1;