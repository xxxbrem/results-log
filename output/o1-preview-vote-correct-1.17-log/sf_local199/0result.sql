WITH rentals_per_month AS (
    SELECT 
        s."store_id", 
        SUBSTRING(r."rental_date", 1, 4) AS "year", 
        SUBSTRING(r."rental_date", 6, 2) AS "month", 
        COUNT(*) AS "total_rentals"
    FROM 
        SQLITE_SAKILA.SQLITE_SAKILA.RENTAL r
    JOIN 
        SQLITE_SAKILA.SQLITE_SAKILA.STAFF s ON r."staff_id" = s."staff_id"
    GROUP BY 
        s."store_id", 
        SUBSTRING(r."rental_date", 1, 4), 
        SUBSTRING(r."rental_date", 6, 2)
)
SELECT
    "store_id",
    "year",
    "month",
    "total_rentals"
FROM (
    SELECT 
        "store_id", 
        "year", 
        "month", 
        "total_rentals",
        ROW_NUMBER() OVER (
            PARTITION BY "store_id" 
            ORDER BY "total_rentals" DESC NULLS LAST
        ) AS rn
    FROM rentals_per_month
) ranked
WHERE rn = 1;