SELECT
    t1."GeoName",
    ROUND(t2."Earnings_per_job_avg" - t1."Earnings_per_job_avg", 4) AS "Increase_in_Avg_Earnings_per_Job"
FROM
    SDOH.SDOH_BEA_CAINC30.FIPS t1
JOIN
    SDOH.SDOH_BEA_CAINC30.FIPS t2
    ON t1."GeoFIPS" = t2."GeoFIPS"
WHERE
    t1."Year" = DATE '2012-01-01'
    AND t2."Year" = DATE '2017-01-01'
    AND t1."GeoName" LIKE '%, MA';