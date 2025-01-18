SELECT
    ROUND(MEDIAN("TotalSales"), 4) AS "median_total_sales"
FROM (
    SELECT
        c."Country",
        SUM(i."Total") AS "TotalSales"
    FROM "CHINOOK"."CHINOOK"."CUSTOMERS" c
    JOIN "CHINOOK"."CHINOOK"."INVOICES" i ON c."CustomerId" = i."CustomerId"
    GROUP BY c."Country"
    HAVING COUNT(DISTINCT c."CustomerId") > 4
);