SELECT
    sales."salespersonid",
    sales."year",
    ROUND(sales."total_sales", 4) AS "total_sales",
    ROUND(quota."sales_quota", 4) AS "sales_quota",
    ROUND(sales."total_sales" - quota."sales_quota", 4) AS "difference"
FROM
    (
        SELECT
            CAST(NULLIF("salespersonid", '') AS NUMBER) AS "salespersonid",
            EXTRACT(YEAR FROM TRY_TO_TIMESTAMP_NTZ(NULLIF("orderdate", ''))) AS "year",
            SUM("totaldue") AS "total_sales"
        FROM
            "ADVENTUREWORKS"."ADVENTUREWORKS"."SALESORDERHEADER"
        WHERE
            "salespersonid" IS NOT NULL
            AND "salespersonid" <> ''
            AND TRY_TO_NUMBER("salespersonid") IS NOT NULL
            AND "orderdate" IS NOT NULL
            AND "orderdate" <> ''
            AND TRY_TO_TIMESTAMP_NTZ("orderdate") IS NOT NULL
        GROUP BY
            CAST(NULLIF("salespersonid", '') AS NUMBER),
            EXTRACT(YEAR FROM TRY_TO_TIMESTAMP_NTZ(NULLIF("orderdate", '')))
    ) AS sales
INNER JOIN
    (
        SELECT
            "BusinessEntityID" AS "salespersonid",
            EXTRACT(YEAR FROM TRY_TO_TIMESTAMP_NTZ("QuotaDate")) AS "year",
            SUM("SalesQuota") AS "sales_quota"
        FROM
            "ADVENTUREWORKS"."ADVENTUREWORKS"."SALESPERSONQUOTAHISTORY"
        WHERE
            "QuotaDate" IS NOT NULL
            AND "QuotaDate" <> ''
            AND TRY_TO_TIMESTAMP_NTZ("QuotaDate") IS NOT NULL
        GROUP BY
            "BusinessEntityID",
            EXTRACT(YEAR FROM TRY_TO_TIMESTAMP_NTZ("QuotaDate"))
    ) AS quota
ON
    sales."salespersonid" = quota."salespersonid"
    AND sales."year" = quota."year"
ORDER BY
    sales."salespersonid",
    sales."year";