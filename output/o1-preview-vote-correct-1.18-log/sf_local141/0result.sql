SELECT
    q."SalesPersonID",
    q."Year",
    ROUND(q."SalesQuota", 4) AS "SalesQuota",
    ROUND(COALESCE(s."TotalSales", 0), 4) AS "TotalSales",
    ROUND(COALESCE(s."TotalSales", 0) - q."SalesQuota", 4) AS "Difference"
FROM
    (
        SELECT
            "BusinessEntityID" AS "SalesPersonID",
            EXTRACT(YEAR FROM TO_DATE("QuotaDate", 'YYYY-MM-DD HH24:MI:SS')) AS "Year",
            SUM("SalesQuota") AS "SalesQuota"
        FROM
            ADVENTUREWORKS.ADVENTUREWORKS.SALESPERSONQUOTAHISTORY
        GROUP BY
            "BusinessEntityID",
            EXTRACT(YEAR FROM TO_DATE("QuotaDate", 'YYYY-MM-DD HH24:MI:SS'))
    ) q
LEFT JOIN
    (
        SELECT
            CAST("salespersonid" AS INT) AS "SalesPersonID",
            EXTRACT(YEAR FROM TO_DATE("orderdate", 'YYYY-MM-DD HH24:MI:SS')) AS "Year",
            SUM("totaldue") AS "TotalSales"
        FROM
            ADVENTUREWORKS.ADVENTUREWORKS.SALESORDERHEADER
        WHERE
            "salespersonid" IS NOT NULL AND "salespersonid" <> ''
        GROUP BY
            CAST("salespersonid" AS INT),
            EXTRACT(YEAR FROM TO_DATE("orderdate", 'YYYY-MM-DD HH24:MI:SS'))
    ) s
ON q."SalesPersonID" = s."SalesPersonID" AND q."Year" = s."Year"
ORDER BY
    q."SalesPersonID", q."Year";