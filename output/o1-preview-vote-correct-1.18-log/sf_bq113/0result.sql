SELECT
  a."county_name" AS "County",
  ROUND(((c."month3_emplvl_23_construction" - b."month3_emplvl_23_construction") / b."month3_emplvl_23_construction") * 100, 4) AS "Percentage_Increase"
FROM BLS.GEO_US_BOUNDARIES.COUNTIES a
JOIN BLS.BLS_QCEW."_2000_Q1" b
  ON a."county_fips_code" = b."area_fips"
JOIN BLS.BLS_QCEW."_2018_Q4" c
  ON a."county_fips_code" = c."area_fips"
WHERE a."state_fips_code" = '49'
  AND b."month3_emplvl_23_construction" IS NOT NULL
  AND c."month3_emplvl_23_construction" IS NOT NULL
  AND b."month3_emplvl_23_construction" > 0
ORDER BY "Percentage_Increase" DESC NULLS LAST
LIMIT 1;