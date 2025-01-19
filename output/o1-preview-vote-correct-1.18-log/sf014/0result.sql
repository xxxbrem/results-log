WITH NY_Zip_Commuters AS (
    SELECT fcv."ZipCode", SUM(fcv."CensusValueByZip") AS "TotalCommuters"
    FROM CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."Fact_CensusValues_ACS2021_ByZip" fcv
    JOIN CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."LU_GeographyExpanded" lge
      ON fcv."ZipCode" = lge."ZipCode"
    WHERE lge."PreferredStateAbbrev" = 'NY' AND fcv."MetricID" IN ('B08303_012E', 'B08303_013E')
    GROUP BY fcv."ZipCode"
),
Max_ZipCode AS (
    SELECT "ZipCode", "TotalCommuters"
    FROM NY_Zip_Commuters
    ORDER BY "TotalCommuters" DESC NULLS LAST
    LIMIT 1
),
StateBenchmark AS (
    SELECT SUM("StateBenchmarkValue") AS "StateBenchmark", MAX("TotalStatePopulation") AS "StatePopulation"
    FROM CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE.PUBLIC."Fact_StateBenchmark_ACS2021"
    WHERE "StateAbbrev" = 'NY' AND "MetricID" IN ('B08303_012E', 'B08303_013E')
)
SELECT m."ZipCode", ROUND(m."TotalCommuters", 4) AS "TotalCommuters",
       ROUND(sb."StateBenchmark", 4) AS "StateBenchmark", sb."StatePopulation"
FROM Max_ZipCode m
CROSS JOIN StateBenchmark sb;