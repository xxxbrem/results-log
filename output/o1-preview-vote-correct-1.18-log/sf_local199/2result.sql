WITH rental_counts AS (
    SELECT
        s."store_id" AS "Store_id",
        EXTRACT(YEAR FROM TRY_TO_TIMESTAMP(r."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "Year",
        EXTRACT(MONTH FROM TRY_TO_TIMESTAMP(r."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "Month",
        COUNT(*) AS "Total_rentals"
    FROM
        SQLITE_SAKILA.SQLITE_SAKILA.RENTAL r
        JOIN SQLITE_SAKILA.SQLITE_SAKILA.STAFF s ON r."staff_id" = s."staff_id"
    WHERE
        TRY_TO_TIMESTAMP(r."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3') IS NOT NULL
    GROUP BY
        s."store_id", "Year", "Month"
)
SELECT
    "Store_id", "Year", "Month", "Total_rentals"
FROM
    (
        SELECT
            rc.*,
            ROW_NUMBER() OVER (
                PARTITION BY rc."Store_id"
                ORDER BY rc."Total_rentals" DESC NULLS LAST, rc."Year", rc."Month"
            ) AS rn
        FROM
            rental_counts rc
    ) sub
WHERE
    rn = 1
ORDER BY
    "Store_id" NULLS LAST;