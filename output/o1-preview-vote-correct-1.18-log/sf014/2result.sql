WITH 
StateBenchmark AS (
  SELECT
    ROUND(SUM("StateBenchmarkValue"), 4) AS "StateBenchmark",
    MAX("TotalStatePopulation") AS "StatePopulation"
  FROM "CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE"."PUBLIC"."Fact_StateBenchmark_ACS2021"
  WHERE "StateAbbrev" = 'NY' AND "MetricID" IN ('B08303_012E', 'B08303_013E')
),
ZipCommuters AS (
  SELECT
    fcz."ZipCode",
    ROUND(SUM(fcz."CensusValueByZip"), 4) AS "TotalCommutersOverOneHour"
  FROM "CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE"."PUBLIC"."Fact_CensusValues_ACS2021_ByZip" fcz
  JOIN "CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE"."PUBLIC"."LU_GeographyExpanded" lge
    ON fcz."ZipCode" = lge."ZipCode"
  WHERE lge."PreferredStateAbbrev" = 'NY'
    AND fcz."MetricID" IN ('B08303_012E', 'B08303_013E')
  GROUP BY fcz."ZipCode"
)
SELECT
  zc."ZipCode",
  zc."TotalCommutersOverOneHour",
  sb."StateBenchmark",
  sb."StatePopulation"
FROM ZipCommuters zc
CROSS JOIN StateBenchmark sb
ORDER BY zc."TotalCommutersOverOneHour" DESC NULLS LAST
LIMIT 1;