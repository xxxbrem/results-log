SELECT
    c."name" AS category_name,
    SUM(f."length") / 60 AS total_rental_hours
FROM
    PAGILA.PAGILA.RENTAL r
    JOIN PAGILA.PAGILA.CUSTOMER cu ON r."customer_id" = cu."customer_id"
    JOIN PAGILA.PAGILA.ADDRESS a ON cu."address_id" = a."address_id"
    JOIN PAGILA.PAGILA.CITY ci ON a."city_id" = ci."city_id"
    JOIN PAGILA.PAGILA.INVENTORY i ON r."inventory_id" = i."inventory_id"
    JOIN PAGILA.PAGILA.FILM f ON i."film_id" = f."film_id"
    JOIN PAGILA.PAGILA.FILM_CATEGORY fc ON f."film_id" = fc."film_id"
    JOIN PAGILA.PAGILA.CATEGORY c ON fc."category_id" = c."category_id"
WHERE
    ci."city" LIKE 'A%' OR ci."city" LIKE '%-%'
GROUP BY
    c."name"
ORDER BY
    total_rental_hours DESC NULLS LAST
LIMIT 1;