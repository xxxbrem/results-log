WITH top_actors AS (
    SELECT "actor_id"
    FROM (
        SELECT "actor_id", COUNT(*) AS "film_count"
        FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."FILM_ACTOR"
        GROUP BY "actor_id"
        ORDER BY "film_count" DESC NULLS LAST
        LIMIT 5
    )
),
films_with_top_actors AS (
    SELECT DISTINCT "film_id"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."FILM_ACTOR"
    WHERE "actor_id" IN (SELECT "actor_id" FROM top_actors)
),
inventories_with_top_actors AS (
    SELECT DISTINCT "inventory_id"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."INVENTORY"
    WHERE "film_id" IN (SELECT "film_id" FROM films_with_top_actors)
),
customers_who_rented_top_actors_films AS (
    SELECT DISTINCT "customer_id"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL"
    WHERE "inventory_id" IN (SELECT "inventory_id" FROM inventories_with_top_actors)
)
SELECT ROUND(
    (COUNT(DISTINCT customers_who_rented_top_actors_films."customer_id")::FLOAT /
     (SELECT COUNT(DISTINCT "customer_id") FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."CUSTOMER")) * 100,
    4
) AS "Percentage_of_customers"
FROM customers_who_rented_top_actors_films;