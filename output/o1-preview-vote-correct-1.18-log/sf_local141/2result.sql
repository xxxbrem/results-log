WITH TotalSales AS (
    SELECT
        CAST("salesorderheader"."salespersonid" AS NUMBER(38,0)) AS "SalespersonID",
        YEAR(TO_TIMESTAMP_NTZ("salesorderheader"."orderdate", 'YYYY-MM-DD HH24:MI:SS')) AS "Year",
        SUM("salesorderheader"."totaldue") AS "TotalSales"
    FROM
        "ADVENTUREWORKS"."ADVENTUREWORKS"."SALESORDERHEADER" AS "salesorderheader"
    WHERE
        "salesorderheader"."salespersonid" IS NOT NULL
        AND "salesorderheader"."salespersonid" <> ''
    GROUP BY
        CAST("salesorderheader"."salespersonid" AS NUMBER(38,0)),
        YEAR(TO_TIMESTAMP_NTZ("salesorderheader"."orderdate", 'YYYY-MM-DD HH24:MI:SS'))
),
TotalQuota AS (
    SELECT
        "salespersonquothist"."BusinessEntityID" AS "SalespersonID",
        YEAR(TO_TIMESTAMP_NTZ("salespersonquothist"."QuotaDate", 'YYYY-MM-DD HH24:MI:SS')) AS "Year",
        SUM("salespersonquothist"."SalesQuota") AS "SalesQuota"
    FROM
        "ADVENTUREWORKS"."ADVENTUREWORKS"."SALESPERSONQUOTAHISTORY" AS "salespersonquothist"
    GROUP BY
        "salespersonquothist"."BusinessEntityID",
        YEAR(TO_TIMESTAMP_NTZ("salespersonquothist"."QuotaDate", 'YYYY-MM-DD HH24:MI:SS'))
)
SELECT
    COALESCE(ts."SalespersonID", tq."SalespersonID") AS "SalespersonID",
    COALESCE(ts."Year", tq."Year") AS "Year",
    ROUND(COALESCE(ts."TotalSales", 0), 4) AS "TotalSales",
    ROUND(COALESCE(tq."SalesQuota", 0), 4) AS "SalesQuota",
    ROUND(COALESCE(ts."TotalSales", 0) - COALESCE(tq."SalesQuota", 0), 4) AS "Difference"
FROM
    TotalSales ts
FULL OUTER JOIN
    TotalQuota tq
ON
    ts."SalespersonID" = tq."SalespersonID"
    AND ts."Year" = tq."Year"
ORDER BY
    COALESCE(ts."SalespersonID", tq."SalespersonID"),
    COALESCE(ts."Year", tq."Year");