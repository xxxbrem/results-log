SELECT t2015."geo_id", ca."tract_ce"
FROM CENSUS_BUREAU_ACS_1.CENSUS_BUREAU_ACS.CENSUSTRACT_2015_5YR t2015
INNER JOIN CENSUS_BUREAU_ACS_1.CENSUS_BUREAU_ACS.CENSUSTRACT_2018_5YR t2018
  ON t2015."geo_id" = t2018."geo_id"
INNER JOIN CENSUS_BUREAU_ACS_1.GEO_CENSUS_TRACTS.CENSUS_TRACTS_CALIFORNIA ca
  ON t2015."geo_id" = ca."geo_id"
WHERE t2015."median_income" IS NOT NULL AND t2018."median_income" IS NOT NULL
ORDER BY (t2018."median_income" - t2015."median_income") DESC NULLS LAST
LIMIT 1;