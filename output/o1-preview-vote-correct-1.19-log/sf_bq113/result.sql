WITH employment_2000 AS (
    SELECT
        c."geo_id",
        c."county_name",
        e."month3_emplvl_23_construction" AS "employment_2000"
    FROM BLS.GEO_US_BOUNDARIES."COUNTIES" c
    JOIN BLS.BLS_QCEW."_2000_Q1" e
        ON c."geo_id" = e."geoid"
    WHERE c."state_fips_code" = '49'
      AND e."month3_emplvl_23_construction" IS NOT NULL
),
employment_2018 AS (
    SELECT
        c."geo_id",
        c."county_name",
        e."month3_emplvl_23_construction" AS "employment_2018"
    FROM BLS.GEO_US_BOUNDARIES."COUNTIES" c
    JOIN BLS.BLS_QCEW."_2018_Q4" e
        ON c."geo_id" = e."geoid"
    WHERE c."state_fips_code" = '49'
      AND e."month3_emplvl_23_construction" IS NOT NULL
)
SELECT
    e18."county_name",
    e18."employment_2018",
    e00."employment_2000",
    ROUND(((e18."employment_2018" - e00."employment_2000") / e00."employment_2000") * 100, 4) AS "percentage_increase"
FROM employment_2000 e00
JOIN employment_2018 e18
    ON e00."geo_id" = e18."geo_id"
WHERE e00."employment_2000" > 0
ORDER BY "percentage_increase" DESC NULLS LAST
LIMIT 1;