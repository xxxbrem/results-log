SELECT "store_id", "year", "month", "total_rentals"
FROM (
    SELECT s."store_id",
           strftime('%Y', r."rental_date") AS "year",
           strftime('%m', r."rental_date") AS "month",
           COUNT(*) AS "total_rentals",
           RANK() OVER (PARTITION BY s."store_id" ORDER BY COUNT(*) DESC) AS "rank"
    FROM "rental" r
    JOIN "staff" s ON r."staff_id" = s."staff_id"
    GROUP BY s."store_id", "year", "month"
) sub
WHERE "rank" = 1
ORDER BY "store_id", "year", "month";