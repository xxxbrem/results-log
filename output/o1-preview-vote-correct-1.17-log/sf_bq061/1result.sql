SELECT
    a."geo_id",
    c."tract_ce",
    ROUND(a."median_income", 4) AS "median_income_2015",
    ROUND(b."median_income", 4) AS "median_income_2018",
    ROUND((b."median_income" - a."median_income"), 4) AS "income_increase"
FROM
    "CENSUS_BUREAU_ACS_1"."CENSUS_BUREAU_ACS"."CENSUSTRACT_2015_5YR" AS a
JOIN
    "CENSUS_BUREAU_ACS_1"."CENSUS_BUREAU_ACS"."CENSUSTRACT_2018_5YR" AS b
    ON a."geo_id" = b."geo_id"
JOIN
    "CENSUS_BUREAU_ACS_1"."GEO_CENSUS_TRACTS"."US_CENSUS_TRACTS_NATIONAL" AS c
    ON a."geo_id" = c."geo_id"
WHERE
    a."median_income" IS NOT NULL
    AND b."median_income" IS NOT NULL
    AND c."state_fips_code" = '06'
ORDER BY
    "income_increase" DESC NULLS LAST
LIMIT 1;