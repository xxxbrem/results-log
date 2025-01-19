SELECT
  f1."GeoName",
  ROUND(f2."Earnings_per_job_avg" - f1."Earnings_per_job_avg", 4) AS "Increase_in_Earnings_per_job"
FROM
  SDOH.SDOH_BEA_CAINC30.FIPS f1
JOIN
  SDOH.SDOH_BEA_CAINC30.FIPS f2
ON
  f1."GeoName" = f2."GeoName"
WHERE
  f1."Year" = '2012-01-01' AND
  f2."Year" = '2017-01-01' AND
  f1."GeoName" LIKE '%MA'
ORDER BY
  "Increase_in_Earnings_per_job" DESC NULLS LAST;