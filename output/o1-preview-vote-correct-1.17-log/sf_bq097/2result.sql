SELECT
    t1."GeoName",
    CAST(t2."Earnings_per_job_avg" - t1."Earnings_per_job_avg" AS NUMBER(18,4)) AS "Increase_in_Avg_Earnings"
FROM
    SDOH.SDOH_BEA_CAINC30.FIPS t1
JOIN
    SDOH.SDOH_BEA_CAINC30.FIPS t2
    ON t1."GeoName" = t2."GeoName"
WHERE
    t1."Year" = '2012-01-01'
    AND t2."Year" = '2017-01-01'
    AND t1."GeoName" LIKE '% MA';