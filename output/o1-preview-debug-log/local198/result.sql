WITH country_sales AS (
    SELECT "Country", SUM("Total") AS "TotalSales"
    FROM "customers"
    JOIN "invoices" ON "customers"."CustomerId" = "invoices"."CustomerId"
    GROUP BY "Country"
    HAVING COUNT(DISTINCT "customers"."CustomerId") > 4
),
ordered_sales AS (
    SELECT "TotalSales"
    FROM country_sales
    ORDER BY "TotalSales"
)
SELECT AVG("TotalSales") AS median_total_sales
FROM (
    SELECT "TotalSales" FROM ordered_sales LIMIT 2 OFFSET 1
) t;