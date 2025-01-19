SELECT
    CATEGORY."name" AS Category,
    CAST(SUM(DATEDIFF('second',
        TRY_TO_TIMESTAMP(RENTAL."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3'),
        TRY_TO_TIMESTAMP(RENTAL."return_date", 'YYYY-MM-DD HH24:MI:SS.FF3')
    ) / 3600.0) AS DECIMAL(18,4)) AS Total_rental_hours
FROM
    PAGILA.PAGILA.RENTAL
    JOIN PAGILA.PAGILA.CUSTOMER ON RENTAL."customer_id" = CUSTOMER."customer_id"
    JOIN PAGILA.PAGILA.ADDRESS ON CUSTOMER."address_id" = ADDRESS."address_id"
    JOIN PAGILA.PAGILA.CITY ON ADDRESS."city_id" = CITY."city_id"
    JOIN PAGILA.PAGILA.INVENTORY ON RENTAL."inventory_id" = INVENTORY."inventory_id"
    JOIN PAGILA.PAGILA.FILM_CATEGORY ON INVENTORY."film_id" = FILM_CATEGORY."film_id"
    JOIN PAGILA.PAGILA.CATEGORY ON FILM_CATEGORY."category_id" = CATEGORY."category_id"
WHERE
    (CITY."city" ILIKE 'A%' OR CITY."city" LIKE '%-%')
    AND RENTAL."return_date" IS NOT NULL
GROUP BY
    CATEGORY."name"
ORDER BY
    Total_rental_hours DESC NULLS LAST
LIMIT 1;