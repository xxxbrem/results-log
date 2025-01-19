SELECT t2015."geo_id" AS "tract_code"
FROM CENSUS_BUREAU_ACS_1.CENSUS_BUREAU_ACS."CENSUSTRACT_2015_5YR" AS t2015
JOIN CENSUS_BUREAU_ACS_1.CENSUS_BUREAU_ACS."CENSUSTRACT_2018_5YR" AS t2018
    ON t2015."geo_id" = t2018."geo_id"
WHERE SUBSTRING(t2015."geo_id", 10, 2) = '06'  -- Filter for California (State FIPS code '06')
    AND t2015."median_income" IS NOT NULL
    AND t2018."median_income" IS NOT NULL
ORDER BY (t2018."median_income" - t2015."median_income") DESC NULLS LAST
LIMIT 1;