WITH counties_utah AS (
    SELECT "county_name", "geo_id"
    FROM "BLS"."GEO_US_BOUNDARIES"."COUNTIES"
    WHERE "state_fips_code" = '49'
),
empl_2000 AS (
    SELECT "geoid", "month3_emplvl_23_construction" AS "emplvl_2000"
    FROM "BLS"."BLS_QCEW"."_2000_Q1"
    WHERE "month3_emplvl_23_construction" IS NOT NULL
),
empl_2018 AS (
    SELECT "geoid", "month3_emplvl_23_construction" AS "emplvl_2018"
    FROM "BLS"."BLS_QCEW"."_2018_Q1"
    WHERE "month3_emplvl_23_construction" IS NOT NULL
)
SELECT c."county_name" AS "County",
       ROUND(((e2018."emplvl_2018" - e2000."emplvl_2000") / e2000."emplvl_2000") * 100, 4) AS "Percentage_Increase"
FROM counties_utah c
LEFT JOIN empl_2000 e2000 ON c."geo_id" = e2000."geoid"
LEFT JOIN empl_2018 e2018 ON c."geo_id" = e2018."geoid"
WHERE e2000."emplvl_2000" > 0
  AND e2018."emplvl_2018" IS NOT NULL
ORDER BY "Percentage_Increase" DESC NULLS LAST
LIMIT 1;