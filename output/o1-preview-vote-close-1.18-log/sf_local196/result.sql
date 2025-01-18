WITH
FirstRental AS (
    SELECT
        "customer_id",
        "rental_id",
        "rental_date",
        "inventory_id",
        ROW_NUMBER() OVER (PARTITION BY "customer_id" ORDER BY "rental_date") AS rn
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL"
),
FirstFilm AS (
    SELECT fr."customer_id", fr."rental_date", i."film_id"
    FROM FirstRental fr
    JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."INVENTORY" i ON fr."inventory_id" = i."inventory_id"
    WHERE fr.rn = 1
),
FirstRating AS (
    SELECT ff."customer_id", ff."rental_date", f."rating"
    FROM FirstFilm ff
    JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."FILM" f ON ff."film_id" = f."film_id"
),
CustomerSpend AS (
    SELECT "customer_id", SUM("amount") AS total_spend
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
    GROUP BY "customer_id"
),
CustomerRentals AS (
    SELECT "customer_id", (COUNT(*) - 1) AS subsequent_rentals
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL"
    GROUP BY "customer_id"
)
SELECT
    fr."rating" AS "Rating",
    ROUND(AVG(cs.total_spend), 4) AS "Average_Total_Spend",
    ROUND(AVG(cr.subsequent_rentals), 4) AS "Average_Subsequent_Rentals"
FROM FirstRating fr
JOIN CustomerSpend cs ON fr."customer_id" = cs."customer_id"
JOIN CustomerRentals cr ON fr."customer_id" = cr."customer_id"
GROUP BY fr."rating"
ORDER BY fr."rating";