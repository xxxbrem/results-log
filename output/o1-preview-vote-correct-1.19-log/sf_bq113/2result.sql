SELECT c."county_name",
       e2000."month3_emplvl_23_construction" AS "emplvl_2000",
       e2018."month3_emplvl_23_construction" AS "emplvl_2018",
       ROUND(((e2018."month3_emplvl_23_construction" - e2000."month3_emplvl_23_construction")
        / NULLIF(e2000."month3_emplvl_23_construction", 0) * 100), 4) AS "pct_increase"
FROM "BLS"."GEO_US_BOUNDARIES"."COUNTIES" c
LEFT JOIN "BLS"."BLS_QCEW"."_2000_Q1" e2000
    ON c."county_fips_code" = e2000."area_fips"
LEFT JOIN "BLS"."BLS_QCEW"."_2018_Q4" e2018
    ON c."county_fips_code" = e2018."area_fips"
WHERE c."state_fips_code" = '49'
    AND e2000."month3_emplvl_23_construction" IS NOT NULL AND e2000."month3_emplvl_23_construction" <> 0
    AND e2018."month3_emplvl_23_construction" IS NOT NULL
ORDER BY "pct_increase" DESC NULLS LAST, c."county_name"
LIMIT 1;