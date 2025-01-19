SELECT 
   PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "TotalSales") AS "median_total_sales"
FROM (
   SELECT c."Country", SUM(i."Total") AS "TotalSales"
   FROM CHINOOK.CHINOOK."INVOICES" i
   JOIN CHINOOK.CHINOOK."CUSTOMERS" c ON i."CustomerId" = c."CustomerId"
   WHERE c."Country" IN (
      SELECT "Country"
      FROM CHINOOK.CHINOOK."CUSTOMERS"
      GROUP BY "Country"
      HAVING COUNT(*) > 4
   )
   GROUP BY c."Country"
) sub;