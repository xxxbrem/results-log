SELECT t."DATE",
       ROUND(SUM(t."VALUE"), 4) AS "Cumulative_Percentage"
FROM "US_REAL_ESTATE"."CYBERSYN"."FHFA_MORTGAGE_PERFORMANCE_TIMESERIES" t
WHERE t."GEO_ID" = 'geoId/06'
  AND t."DATE" BETWEEN '2023-01-01' AND '2023-12-31'
  AND t."VARIABLE" IN (
    'Percent_90_to_180_Days_Past_Due_Date_All Mortgages',
    'Percent_in_Forbearance_All Mortgages',
    'Percent_in_the_Process_of_Foreclosure,_Bankruptcy,_or_Deed_in_Lieu_All Mortgages'
  )
GROUP BY t."DATE"
ORDER BY t."DATE";