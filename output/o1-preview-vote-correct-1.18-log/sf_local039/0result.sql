SELECT
    C."name" AS category,
    ROUND(SUM(
        DATEDIFF('second',
            TRY_TO_TIMESTAMP(NULLIF(R."rental_date", '')),
            TRY_TO_TIMESTAMP(NULLIF(R."return_date", ''))
        ) / 3600.0
    ), 4) AS total_rental_hours
FROM
    PAGILA.PAGILA."RENTAL" R
    JOIN PAGILA.PAGILA."CUSTOMER" CU ON R."customer_id" = CU."customer_id"
    JOIN PAGILA.PAGILA."ADDRESS" A ON CU."address_id" = A."address_id"
    JOIN PAGILA.PAGILA."CITY" CI ON A."city_id" = CI."city_id"
    JOIN PAGILA.PAGILA."INVENTORY" I ON R."inventory_id" = I."inventory_id"
    JOIN PAGILA.PAGILA."FILM_CATEGORY" FC ON I."film_id" = FC."film_id"
    JOIN PAGILA.PAGILA."CATEGORY" C ON FC."category_id" = C."category_id"
WHERE
    (CI."city" LIKE 'A%' OR CI."city" LIKE '%-%')
    AND TRY_TO_TIMESTAMP(NULLIF(R."rental_date", '')) IS NOT NULL
    AND TRY_TO_TIMESTAMP(NULLIF(R."return_date", '')) IS NOT NULL
GROUP BY
    C."name"
ORDER BY
    total_rental_hours DESC NULLS LAST
LIMIT 1;