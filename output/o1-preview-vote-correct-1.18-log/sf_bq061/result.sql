SELECT
    RIGHT(t2015."geo_id", 11) AS "geo_id",
    RIGHT(t2015."geo_id", 6) AS "tract_ce"
FROM
    "CENSUS_BUREAU_ACS_1"."CENSUS_BUREAU_ACS"."CENSUSTRACT_2015_5YR" AS t2015
JOIN
    "CENSUS_BUREAU_ACS_1"."CENSUS_BUREAU_ACS"."CENSUSTRACT_2018_5YR" AS t2018
ON
    RIGHT(t2015."geo_id", 11) = RIGHT(t2018."geo_id", 11)
WHERE
    LEFT(RIGHT(t2015."geo_id", 11), 2) = '06' AND
    t2015."median_income" IS NOT NULL AND
    t2018."median_income" IS NOT NULL
ORDER BY
    ROUND((t2018."median_income" - t2015."median_income"), 4) DESC NULLS LAST
LIMIT 1;