SELECT cat."name" AS "category",
       ROUND(SUM(DATEDIFF('second',
                          TO_TIMESTAMP(r."rental_date", 'YYYY-MM-DD HH24:MI:SS.FF3'),
                          TO_TIMESTAMP(r."return_date", 'YYYY-MM-DD HH24:MI:SS.FF3')))/3600.0, 4) AS "total_rental_hours"
FROM PAGILA.PAGILA.RENTAL r
JOIN PAGILA.PAGILA.CUSTOMER c ON r."customer_id" = c."customer_id"
JOIN PAGILA.PAGILA.ADDRESS a ON c."address_id" = a."address_id"
JOIN PAGILA.PAGILA.CITY ci ON a."city_id" = ci."city_id"
JOIN PAGILA.PAGILA.INVENTORY i ON r."inventory_id" = i."inventory_id"
JOIN PAGILA.PAGILA.FILM_CATEGORY fc ON i."film_id" = fc."film_id"
JOIN PAGILA.PAGILA.CATEGORY cat ON fc."category_id" = cat."category_id"
WHERE (ci."city" LIKE 'A%' OR ci."city" LIKE '%-%')
  AND r."rental_date" IS NOT NULL AND r."rental_date" <> ''
  AND r."return_date" IS NOT NULL AND r."return_date" <> ''
GROUP BY cat."name"
ORDER BY "total_rental_hours" DESC NULLS LAST
LIMIT 1;