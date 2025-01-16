SELECT 
    t2015."geo_id", 
    tracts."tract_ce", 
    ROUND(t2018."median_income" - t2015."median_income", 4) AS "increase_in_median_income"
FROM 
    "CENSUS_BUREAU_ACS_1"."CENSUS_BUREAU_ACS"."CENSUSTRACT_2015_5YR" AS t2015
JOIN 
    "CENSUS_BUREAU_ACS_1"."CENSUS_BUREAU_ACS"."CENSUSTRACT_2018_5YR" AS t2018
    ON t2015."geo_id" = t2018."geo_id"
JOIN
    "CENSUS_BUREAU_ACS_1"."GEO_CENSUS_TRACTS"."US_CENSUS_TRACTS_NATIONAL" AS tracts
    ON t2015."geo_id" = tracts."geo_id"
WHERE 
    tracts."state_fips_code" = '06'
    AND t2015."median_income" IS NOT NULL
    AND t2018."median_income" IS NOT NULL
ORDER BY 
    (t2018."median_income" - t2015."median_income") DESC NULLS LAST
LIMIT 1;