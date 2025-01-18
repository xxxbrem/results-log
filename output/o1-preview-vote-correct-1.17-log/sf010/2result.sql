SELECT 
    t."DATE" AS date,
    ROUND(SUM(t."VALUE") * 100, 4) AS cumulative_percentage_near_default
FROM
    US_REAL_ESTATE.CYBERSYN.FHFA_MORTGAGE_PERFORMANCE_TIMESERIES t
WHERE
    t."GEO_ID" = 'geoId/06'
    AND t."VARIABLE" IN (
        'Percent_90_to_180_Days_Past_Due_Date_All Mortgages',
        'Percent_in_Forbearance_All Mortgages',
        'Percent_in_the_Process_of_Foreclosure,_Bankruptcy,_or_Deed_in_Lieu_All Mortgages'
    )
    AND t."DATE" BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY
    t."DATE"
ORDER BY
    t."DATE" ASC;