SELECT 
    c."county_name", 
    e2000."month3_emplvl_23_construction" AS "employment_2000",
    e2018."month3_emplvl_23_construction" AS "employment_2018",
    ROUND(
        ((e2018."month3_emplvl_23_construction" - e2000."month3_emplvl_23_construction") / e2000."month3_emplvl_23_construction") * 100,
        4
    ) AS "percentage_increase"
FROM 
    BLS.BLS_QCEW."_2000_Q1" AS e2000
INNER JOIN 
    BLS.BLS_QCEW."_2018_Q1" AS e2018 ON e2000."area_fips" = e2018."area_fips"
INNER JOIN 
    BLS.GEO_US_BOUNDARIES.COUNTIES AS c ON e2000."area_fips" = TO_NUMBER(c."county_fips_code")
WHERE 
    e2000."area_fips" BETWEEN 49000 AND 49999 AND
    e2000."month3_emplvl_23_construction" > 0 AND
    e2018."month3_emplvl_23_construction" IS NOT NULL
ORDER BY 
    "percentage_increase" DESC NULLS LAST
LIMIT 1;