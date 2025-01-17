SELECT
    cat."name" AS category_name,
    SUM(DATEDIFF('hour', 
        TRY_TO_TIMESTAMP(r."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3'), 
        TRY_TO_TIMESTAMP(r."return_date", 'YYYY-MM-DD HH24:MI:SS.FF3')
    )) AS total_rental_hours
FROM
    "PAGILA"."PAGILA"."RENTAL" r
JOIN
    "PAGILA"."PAGILA"."INVENTORY" i ON r."inventory_id" = i."inventory_id"
JOIN
    "PAGILA"."PAGILA"."FILM" f ON i."film_id" = f."film_id"
JOIN
    "PAGILA"."PAGILA"."FILM_CATEGORY" fc ON f."film_id" = fc."film_id"
JOIN
    "PAGILA"."PAGILA"."CATEGORY" cat ON fc."category_id" = cat."category_id"
JOIN
    "PAGILA"."PAGILA"."CUSTOMER" cust ON r."customer_id" = cust."customer_id"
JOIN
    "PAGILA"."PAGILA"."ADDRESS" a ON cust."address_id" = a."address_id"
JOIN
    "PAGILA"."PAGILA"."CITY" c ON a."city_id" = c."city_id"
WHERE
    (c."city" LIKE 'A%' OR c."city" LIKE '%-%')
    AND r."rental_date" IS NOT NULL
    AND r."return_date" IS NOT NULL
    AND TRY_TO_TIMESTAMP(r."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3') IS NOT NULL
    AND TRY_TO_TIMESTAMP(r."return_date", 'YYYY-MM-DD HH24:MI:SS.FF3') IS NOT NULL
GROUP BY
    cat."name"
ORDER BY
    total_rental_hours DESC NULLS LAST
LIMIT 1;