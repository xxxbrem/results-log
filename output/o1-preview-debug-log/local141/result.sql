SELECT 
    s."salespersonid" AS "SalesPersonID", 
    s."Year", 
    ROUND(s."TotalSales", 4) AS "TotalSales", 
    ROUND(q."SalesQuota", 4) AS "SalesQuota", 
    ROUND(s."TotalSales" - q."SalesQuota", 4) AS "Difference"
FROM
    (
        SELECT "salespersonid", strftime('%Y', "orderdate") AS "Year", SUM("totaldue") AS "TotalSales"
        FROM "salesorderheader"
        WHERE "salespersonid" IS NOT NULL
        GROUP BY "salespersonid", "Year"
    ) AS s
JOIN
    (
        SELECT "BusinessEntityID" AS "salespersonid", strftime('%Y', "QuotaDate") AS "Year", SUM("SalesQuota") AS "SalesQuota"
        FROM "SalesPersonQuotaHistory"
        GROUP BY "BusinessEntityID", "Year"
    ) AS q
ON s."salespersonid" = q."salespersonid" AND s."Year" = q."Year"
ORDER BY s."salespersonid", s."Year";