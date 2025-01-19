SELECT
  f."ZipCode",
  ROUND(f."CensusValueByZip", 4) AS "Total_Commuters",
  ROUND(s."StateBenchmarkValue", 4) AS "State_Benchmark",
  s."TotalStatePopulation" AS "State_Population"
FROM CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."Fact_CensusValues_ACS2021_ByZip" AS f
JOIN CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."LU_GeographyExpanded" AS g
  ON f."ZipCode" = g."ZipCode"
JOIN CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."Fact_StateBenchmark_ACS2021" AS s
  ON s."MetricID" = f."MetricID" AND s."StateAbbrev" = g."PreferredStateAbbrev"
WHERE g."PreferredStateAbbrev" = 'NY' AND f."MetricID" = 'B08303_013E'
ORDER BY f."CensusValueByZip" DESC NULLS LAST
LIMIT 1;