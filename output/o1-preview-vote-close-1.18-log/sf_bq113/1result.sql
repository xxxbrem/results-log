WITH
utah_counties AS (
    SELECT
        "state_fips_code",
        "county_fips_code",
        "county_name"
    FROM BLS.GEO_US_BOUNDARIES."COUNTIES"
    WHERE "state_fips_code" = '49'
),
construction_2000 AS (
    SELECT CAST("area_fips" AS NUMBER) AS "area_fips", "month3_emplvl_23_construction" AS "emplvl_2000"
    FROM BLS.BLS_QCEW."_2000_Q1"
    WHERE "area_fips" LIKE '49%' AND "month3_emplvl_23_construction" IS NOT NULL
),
construction_2018 AS (
    SELECT CAST("area_fips" AS NUMBER) AS "area_fips", "month3_emplvl_23_construction" AS "emplvl_2018"
    FROM BLS.BLS_QCEW."_2018_Q1"
    WHERE "area_fips" LIKE '49%' AND "month3_emplvl_23_construction" IS NOT NULL
),
combined_data AS (
    SELECT
        utah."county_name" AS "County",
        c2000."emplvl_2000",
        c2018."emplvl_2018"
    FROM utah_counties utah
    LEFT JOIN construction_2000 c2000
        ON TO_NUMBER(utah."county_fips_code") = c2000."area_fips"
    LEFT JOIN construction_2018 c2018
        ON TO_NUMBER(utah."county_fips_code") = c2018."area_fips"
)
SELECT
    "County",
    ROUND((( "emplvl_2018" - "emplvl_2000") / "emplvl_2000") * 100, 4) AS "Percentage_Increase"
FROM combined_data
WHERE "emplvl_2000" IS NOT NULL AND "emplvl_2018" IS NOT NULL AND "emplvl_2000" <> 0
ORDER BY "Percentage_Increase" DESC NULLS LAST
LIMIT 1;