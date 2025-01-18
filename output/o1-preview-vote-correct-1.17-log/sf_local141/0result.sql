WITH total_sales AS (
    SELECT
        TO_NUMBER("salespersonid") AS "salesperson_id",
        TO_NUMBER(SUBSTRING("orderdate", 1, 4)) AS "year",
        ROUND(SUM("totaldue"), 4) AS "total_sales"
    FROM ADVENTUREWORKS.ADVENTUREWORKS.SALESORDERHEADER
    WHERE "salespersonid" IS NOT NULL AND "salespersonid" <> ''
    GROUP BY "salesperson_id", "year"
),
total_quota AS (
    SELECT
        "BusinessEntityID" AS "salesperson_id",
        TO_NUMBER(SUBSTRING("QuotaDate", 1, 4)) AS "year",
        ROUND(SUM("SalesQuota"), 4) AS "sales_quota"
    FROM ADVENTUREWORKS.ADVENTUREWORKS.SALESPERSONQUOTAHISTORY
    GROUP BY "salesperson_id", "year"
)
SELECT
    COALESCE(ts."salesperson_id", tq."salesperson_id") AS "salesperson_id",
    COALESCE(ts."year", tq."year") AS "year",
    ts."total_sales",
    tq."sales_quota",
    ROUND(COALESCE(ts."total_sales", 0) - COALESCE(tq."sales_quota", 0), 4) AS "difference"
FROM total_sales ts
FULL OUTER JOIN total_quota tq
    ON ts."salesperson_id" = tq."salesperson_id"
    AND ts."year" = tq."year"
ORDER BY "salesperson_id", "year";