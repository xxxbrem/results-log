WITH top_actors AS (
    SELECT "actor_id"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.FILM_ACTOR
    GROUP BY "actor_id"
    ORDER BY COUNT(*) DESC NULLS LAST
    LIMIT 5
),
films_top_actors AS (
    SELECT DISTINCT "film_id"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.FILM_ACTOR
    WHERE "actor_id" IN (SELECT "actor_id" FROM top_actors)
),
customers_who_rented AS (
    SELECT DISTINCT R."customer_id"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.RENTAL R
    JOIN SQLITE_SAKILA.SQLITE_SAKILA.INVENTORY I ON R."inventory_id" = I."inventory_id"
    WHERE I."film_id" IN (SELECT "film_id" FROM films_top_actors)
),
total_customers AS (
    SELECT COUNT(DISTINCT "customer_id") AS "total_customers"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER
)
SELECT ROUND(
    (SELECT COUNT(DISTINCT "customer_id") FROM customers_who_rented) * 100.0
    / (SELECT "total_customers" FROM total_customers)
    , 4) AS "Percentage_of_Customers";