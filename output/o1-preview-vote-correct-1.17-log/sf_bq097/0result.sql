SELECT T2012."GeoName",
       T2017."Earnings_per_job_avg" - T2012."Earnings_per_job_avg" AS "Earnings_Per_Job_Increase_2012_to_2017"
FROM "SDOH"."SDOH_BEA_CAINC30"."FIPS" AS T2012
JOIN "SDOH"."SDOH_BEA_CAINC30"."FIPS" AS T2017
  ON T2012."GeoName" = T2017."GeoName"
WHERE T2012."Year" = DATE '2012-01-01'
  AND T2017."Year" = DATE '2017-01-01'
  AND T2012."GeoName" LIKE '%MA';