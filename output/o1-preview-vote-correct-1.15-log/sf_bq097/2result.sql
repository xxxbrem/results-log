SELECT t2012."GeoName",
       ROUND(t2017."Earnings_per_job_avg" - t2012."Earnings_per_job_avg", 4) AS "Earnings_increase"
FROM SDOH.SDOH_BEA_CAINC30.FIPS t2012
JOIN SDOH.SDOH_BEA_CAINC30.FIPS t2017
  ON t2012."GeoFIPS" = t2017."GeoFIPS"
WHERE t2012."Year" = '2012-01-01'
  AND t2017."Year" = '2017-01-01'
  AND t2012."GeoName" LIKE '%, MA'
ORDER BY "Earnings_increase" DESC NULLS LAST;