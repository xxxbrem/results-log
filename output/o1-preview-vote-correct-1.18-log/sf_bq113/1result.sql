SELECT c."county_name",
       ROUND(((q2018."month3_emplvl_23_construction" - q2000."month3_emplvl_23_construction") / q2000."month3_emplvl_23_construction") * 100, 4) AS "Increase_rate"
FROM BLS.GEO_US_BOUNDARIES.COUNTIES c
JOIN BLS.BLS_QCEW._2000_Q4 q2000
  ON q2000."area_fips" = c."county_fips_code"
JOIN BLS.BLS_QCEW._2018_Q4 q2018
  ON q2018."area_fips" = c."county_fips_code"
WHERE c."state_fips_code" = '49'
  AND q2000."month3_emplvl_23_construction" IS NOT NULL AND q2000."month3_emplvl_23_construction" > 0
  AND q2018."month3_emplvl_23_construction" IS NOT NULL
ORDER BY "Increase_rate" DESC NULLS LAST
LIMIT 1;