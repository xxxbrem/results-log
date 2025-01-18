WITH top_actors AS (
    SELECT "actor_id"
    FROM (
        SELECT "actor_id", COUNT("film_id") AS "film_count"
        FROM SQLITE_SAKILA.SQLITE_SAKILA."FILM_ACTOR"
        GROUP BY "actor_id"
        ORDER BY "film_count" DESC NULLS LAST
        LIMIT 5
    )
),
films_by_top_actors AS (
    SELECT DISTINCT "film_id"
    FROM SQLITE_SAKILA.SQLITE_SAKILA."FILM_ACTOR" fa
    JOIN top_actors ta ON fa."actor_id" = ta."actor_id"
),
inventory_of_top_films AS (
    SELECT DISTINCT i."inventory_id"
    FROM SQLITE_SAKILA.SQLITE_SAKILA."INVENTORY" i
    JOIN films_by_top_actors fta ON i."film_id" = fta."film_id"
),
customers_who_rented_top_films AS (
    SELECT DISTINCT r."customer_id"
    FROM SQLITE_SAKILA.SQLITE_SAKILA."RENTAL" r
    JOIN inventory_of_top_films iotf ON r."inventory_id" = iotf."inventory_id"
),
total_customers AS (
    SELECT COUNT(DISTINCT "customer_id") AS "total_customers"
    FROM SQLITE_SAKILA.SQLITE_SAKILA."CUSTOMER"
),
customers_who_rented_top_films_count AS (
    SELECT COUNT(DISTINCT "customer_id") AS "customers_who_rented"
    FROM customers_who_rented_top_films
)
SELECT
    ROUND((cwrtfc."customers_who_rented" * 100.0 / tc."total_customers"), 4) AS "Percentage_of_customers"
FROM customers_who_rented_top_films_count cwrtfc
CROSS JOIN total_customers tc;