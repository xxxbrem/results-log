SELECT
  f."ZipCode",
  ROUND(f."CensusValueByZip", 4) AS "TotalCommutersOverOneHour",
  ROUND(s."StateBenchmarkValue", 4) AS "StateBenchmarkForThisDuration",
  s."TotalStatePopulation" AS "StatePopulation"
FROM
  CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."Fact_CensusValues_ACS2021_ByZip" f
JOIN
  CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."LU_GeographyExpanded" l
  ON f."ZipCode" = l."ZipCode"
JOIN
  CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."Fact_StateBenchmark_ACS2021" s
  ON f."MetricID" = s."MetricID" AND s."StateAbbrev" = 'NY'
WHERE
  f."MetricID" = 'B08303_013E' AND
  l."PreferredStateAbbrev" = 'NY'
ORDER BY
  f."CensusValueByZip" DESC NULLS LAST
LIMIT 1;