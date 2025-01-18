WITH
First_Rental AS (
    SELECT
        r."customer_id",
        r."rental_id" AS "first_rental_id",
        r."rental_date" AS "first_rental_date",
        r."inventory_id",
        i."film_id",
        f."rating"
    FROM (
        SELECT
            r.*,
            ROW_NUMBER() OVER (PARTITION BY r."customer_id" ORDER BY r."rental_date", r."rental_id") AS rn
        FROM SQLITE_SAKILA.SQLITE_SAKILA.RENTAL r
    ) r
    JOIN SQLITE_SAKILA.SQLITE_SAKILA.INVENTORY i ON r."inventory_id" = i."inventory_id"
    JOIN SQLITE_SAKILA.SQLITE_SAKILA.FILM f ON i."film_id" = f."film_id"
    WHERE r.rn = 1
),
Total_Spend AS (
    SELECT
        "customer_id",
        SUM("amount") AS "total_spend"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY "customer_id"
),
Subsequent_Rentals AS (
    SELECT
        fr."customer_id",
        COUNT(r2."rental_id") AS "num_subsequent_rentals"
    FROM First_Rental fr
    LEFT JOIN SQLITE_SAKILA.SQLITE_SAKILA.RENTAL r2
        ON fr."customer_id" = r2."customer_id" AND r2."rental_date" > fr."first_rental_date"
    GROUP BY fr."customer_id"
),
Customer_Summary AS (
    SELECT
        fr."rating",
        COALESCE(ts."total_spend", 0) AS "total_spend",
        COALESCE(sr."num_subsequent_rentals", 0) AS "num_subsequent_rentals"
    FROM First_Rental fr
    LEFT JOIN Total_Spend ts ON fr."customer_id" = ts."customer_id"
    LEFT JOIN Subsequent_Rentals sr ON fr."customer_id" = sr."customer_id"
)
SELECT
    "rating" AS "Rating",
    ROUND(AVG("total_spend"), 4) AS "Average_Total_Spend",
    ROUND(AVG("num_subsequent_rentals"), 4) AS "Average_Num_Subsequent_Rentals"
FROM Customer_Summary
GROUP BY "rating"
ORDER BY "rating";