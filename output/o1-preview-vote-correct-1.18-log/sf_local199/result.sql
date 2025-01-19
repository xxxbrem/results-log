WITH rental_counts AS (
    SELECT
        S."store_id",
        EXTRACT(YEAR FROM TO_TIMESTAMP(R."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS year,
        EXTRACT(MONTH FROM TO_TIMESTAMP(R."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS month,
        COUNT(*) AS total_rentals
    FROM
        "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL" R
        JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."STAFF" S ON R."staff_id" = S."staff_id"
    GROUP BY
        S."store_id",
        year,
        month
),
max_rentals AS (
    SELECT
        "store_id",
        MAX(total_rentals) AS max_total_rentals
    FROM
        rental_counts
    GROUP BY
        "store_id"
)
SELECT
    rc."store_id",
    rc.year,
    rc.month,
    rc.total_rentals
FROM
    rental_counts rc
    JOIN max_rentals mr
        ON rc."store_id" = mr."store_id"
        AND rc.total_rentals = mr.max_total_rentals
ORDER BY
    rc."store_id",
    rc.year,
    rc.month;