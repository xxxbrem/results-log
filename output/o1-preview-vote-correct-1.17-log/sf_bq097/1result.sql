SELECT F2012."GeoName",
       ROUND(F2017."Earnings_per_job_avg" - F2012."Earnings_per_job_avg", 4) AS "Earnings_per_job_avg_increase"
FROM SDOH.SDOH_BEA_CAINC30.FIPS AS F2012
JOIN SDOH.SDOH_BEA_CAINC30.FIPS AS F2017
  ON F2012."GeoFIPS" = F2017."GeoFIPS"
WHERE F2012."Year" = '2012-01-01'
  AND F2017."Year" = '2017-01-01'
  AND F2012."GeoName" LIKE '%MA';