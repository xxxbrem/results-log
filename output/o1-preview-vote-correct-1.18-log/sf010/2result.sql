SELECT 
    t."DATE",
    ROUND(SUM(t."VALUE"), 4) AS "Cumulative_percentage"
FROM 
    "US_REAL_ESTATE"."CYBERSYN"."FHFA_MORTGAGE_PERFORMANCE_TIMESERIES" t
JOIN 
    "US_REAL_ESTATE"."CYBERSYN"."FHFA_MORTGAGE_PERFORMANCE_ATTRIBUTES" a
    ON t."VARIABLE" = a."VARIABLE"
WHERE 
    t."GEO_ID" = 'geoId/06'  -- California's GEO_ID
    AND t."DATE" BETWEEN '2023-01-01' AND '2023-12-31'
    AND a."VARIABLE_GROUP" IN (
        'Percent 90 to 180 Days Past Due Date',
        'Percent in Forbearance',
        'Percent in the Process of Foreclosure, Bankruptcy, or Deed in Lieu'
    )
GROUP BY 
    t."DATE"
ORDER BY 
    t."DATE";