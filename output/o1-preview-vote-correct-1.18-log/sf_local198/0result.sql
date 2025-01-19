SELECT
  ROUND(
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "TotalSales"), 4
  ) AS "Median_Total_Sales"
FROM (
  SELECT 
    c."Country",
    SUM(i."Total") AS "TotalSales"
  FROM "CHINOOK"."CHINOOK"."CUSTOMERS" c
  JOIN "CHINOOK"."CHINOOK"."INVOICES" i
    ON c."CustomerId" = i."CustomerId"
  WHERE c."Country" IN (
    SELECT "Country"
    FROM "CHINOOK"."CHINOOK"."CUSTOMERS"
    GROUP BY "Country"
    HAVING COUNT(*) > 4
  )
  GROUP BY c."Country"
) Sub;