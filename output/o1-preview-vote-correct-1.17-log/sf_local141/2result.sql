WITH TotalSales AS (
    SELECT
        CAST("salespersonid" AS NUMBER) AS "salesperson_id",
        YEAR(TO_DATE("orderdate", 'YYYY-MM-DD HH24:MI:SS')) AS "year",
        ROUND(SUM("totaldue"), 4) AS "total_sales"
    FROM ADVENTUREWORKS.ADVENTUREWORKS.SALESORDERHEADER
    WHERE "salespersonid" IS NOT NULL
        AND "salespersonid" <> ''
    GROUP BY CAST("salespersonid" AS NUMBER), YEAR(TO_DATE("orderdate", 'YYYY-MM-DD HH24:MI:SS'))
),
SalesQuota AS (
    SELECT
        "BusinessEntityID" AS "salesperson_id",
        YEAR(TO_DATE("QuotaDate", 'YYYY-MM-DD HH24:MI:SS')) AS "year",
        ROUND(SUM("SalesQuota"), 4) AS "sales_quota"
    FROM ADVENTUREWORKS.ADVENTUREWORKS.SALESPERSONQUOTAHISTORY
    GROUP BY "BusinessEntityID", YEAR(TO_DATE("QuotaDate", 'YYYY-MM-DD HH24:MI:SS'))
)
SELECT
    ts."salesperson_id",
    ts."year",
    ts."total_sales",
    sq."sales_quota",
    ROUND(ts."total_sales" - sq."sales_quota", 4) AS "difference"
FROM TotalSales ts
JOIN SalesQuota sq
    ON ts."salesperson_id" = sq."salesperson_id"
        AND ts."year" = sq."year"
ORDER BY ts."salesperson_id", ts."year";