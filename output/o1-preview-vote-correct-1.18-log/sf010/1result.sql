SELECT "DATE", ROUND(SUM("VALUE"), 4) AS "CumulativePercentage"
FROM "US_REAL_ESTATE"."CYBERSYN"."FHFA_MORTGAGE_PERFORMANCE_TIMESERIES"
WHERE "GEO_ID" = 'geoId/06'
  AND "VARIABLE_NAME" IN (
    'Percent 90 to 180 Days Past Due Date - All Mortgages',
    'Percent in Forbearance - All Mortgages',
    'Percent in the Process of Foreclosure, Bankruptcy, or Deed in Lieu - All Mortgages'
  )
  AND "DATE" BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY "DATE"
ORDER BY "DATE";