WITH TotalState AS (
    SELECT
        SUM("StateBenchmarkValue") AS "state_benchmark",
        MAX("TotalStatePopulation") AS "state_population"
    FROM
        "CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE"."PUBLIC"."Fact_StateBenchmark_ACS2021"
    WHERE
        "StateAbbrev" = 'NY'
        AND "MetricID" IN ('B08303_012E', 'B08303_013E')
),
TotalByZip AS (
    SELECT
        "ZipCode",
        SUM("CensusValueByZip") AS "total_commuters"
    FROM
        "CENSUS_GALAXY__AIML_MODEL_DATA_ENRICHMENT_SAMPLE"."PUBLIC"."Fact_CensusValues_ACS2021_ByZip"
    WHERE
        "MetricID" IN ('B08303_012E', 'B08303_013E')
    GROUP BY
        "ZipCode"
)
SELECT
    t."ZipCode" AS "zip_code",
    ROUND(t."total_commuters", 4) AS "total_commuters",
    s."state_benchmark",
    s."state_population"
FROM
    TotalByZip t
CROSS JOIN
    TotalState s
ORDER BY
    t."total_commuters" DESC NULLS LAST
LIMIT 1;