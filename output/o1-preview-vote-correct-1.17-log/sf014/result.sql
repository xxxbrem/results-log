WITH StateTotals AS (
  SELECT SUM("StateBenchmarkValue") AS "StateBenchmark", MAX("TotalStatePopulation") AS "StatePopulation"
  FROM CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."Fact_StateBenchmark_ACS2021"
  WHERE "MetricID" IN ('B08303_012E', 'B08303_013E') AND "StateAbbrev" = 'NY'
)
SELECT
    fc."ZipCode",
    ROUND(SUM(fc."CensusValueByZip"), 4) AS "TotalCommuters",
    ROUND(st."StateBenchmark", 4) AS "StateBenchmark",
    st."StatePopulation"
FROM CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."Fact_CensusValues_ACS2021_ByZip" fc
JOIN CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."LU_GeographyExpanded" lu ON fc."ZipCode" = lu."ZipCode"
CROSS JOIN StateTotals st
WHERE fc."MetricID" IN ('B08303_012E', 'B08303_013E')
  AND lu."PreferredStateAbbrev" = 'NY'
GROUP BY fc."ZipCode", st."StateBenchmark", st."StatePopulation"
ORDER BY "TotalCommuters" DESC NULLS LAST
LIMIT 1;