WITH first_rentals AS (
    SELECT
        "customer_id",
        MIN("rental_date") AS "first_rental_date"
    FROM
        "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL"
    GROUP BY
        "customer_id"
),
first_rental_details AS (
    SELECT
        fr."customer_id",
        MIN(r."rental_id") AS "first_rental_id",
        fr."first_rental_date"
    FROM
        first_rentals fr
        INNER JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL" r
            ON fr."customer_id" = r."customer_id"
            AND fr."first_rental_date" = r."rental_date"
    GROUP BY
        fr."customer_id",
        fr."first_rental_date"
),
first_rental_info AS (
    SELECT
        frd."customer_id",
        frd."first_rental_date",
        frd."first_rental_id" AS "rental_id",
        r."inventory_id",
        inv."film_id",
        f."rating"
    FROM
        first_rental_details frd
        INNER JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL" r
            ON frd."first_rental_id" = r."rental_id"
        INNER JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."INVENTORY" inv
            ON r."inventory_id" = inv."inventory_id"
        INNER JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."FILM" f
            ON inv."film_id" = f."film_id"
),
customer_total_spend AS (
    SELECT
        "customer_id",
        SUM("amount") AS "total_spend"
    FROM
        "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
    GROUP BY
        "customer_id"
),
customer_subsequent_rentals AS (
    SELECT
        r."customer_id",
        COUNT(*) AS "subsequent_rentals"
    FROM
        "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL" r
        INNER JOIN first_rentals fr
            ON r."customer_id" = fr."customer_id"
    WHERE
        r."rental_date" > fr."first_rental_date"
    GROUP BY
        r."customer_id"
),
customer_summary AS (
    SELECT
        fri."customer_id",
        fri."rating",
        COALESCE(cts."total_spend", 0) AS "total_spend",
        COALESCE(csr."subsequent_rentals", 0) AS "subsequent_rentals"
    FROM
        first_rental_info fri
        LEFT JOIN customer_total_spend cts
            ON fri."customer_id" = cts."customer_id"
        LEFT JOIN customer_subsequent_rentals csr
            ON fri."customer_id" = csr."customer_id"
)
SELECT
    "rating",
    ROUND(AVG("total_spend"), 4) AS "average_total_spend",
    ROUND(AVG("subsequent_rentals"), 4) AS "average_subsequent_rentals"
FROM
    customer_summary
GROUP BY
    "rating"
ORDER BY
    "rating";