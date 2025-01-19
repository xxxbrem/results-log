WITH qualifying_countries AS (
    SELECT "Country"
    FROM "CHINOOK"."CHINOOK"."CUSTOMERS"
    GROUP BY "Country"
    HAVING COUNT(*) > 4
),
total_sales_per_country AS (
    SELECT cust."Country", SUM(inv."Total") AS "TotalSales"
    FROM "CHINOOK"."CHINOOK"."CUSTOMERS" cust
    INNER JOIN "CHINOOK"."CHINOOK"."INVOICES" inv
    ON cust."CustomerId" = inv."CustomerId"
    WHERE cust."Country" IN (SELECT "Country" FROM qualifying_countries)
    GROUP BY cust."Country"
)
SELECT ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "TotalSales"), 4) AS "median_total_sales"
FROM total_sales_per_country;