WITH rental_timestamps AS (
    SELECT rental.*, 
        TRY_TO_TIMESTAMP(rental."rental_date") AS "rental_ts",
        TRY_TO_TIMESTAMP(rental."return_date") AS "return_ts"
    FROM PAGILA.PAGILA.RENTAL rental
    WHERE rental."rental_date" IS NOT NULL 
      AND rental."rental_date" <> ''
      AND rental."return_date" IS NOT NULL 
      AND rental."return_date" <> ''
)
SELECT category."name" AS "Category", 
    ROUND(SUM(DATEDIFF('hours', rental_timestamps."rental_ts", rental_timestamps."return_ts")), 4) AS "TotalRentalHours"
FROM rental_timestamps
JOIN PAGILA.PAGILA.CUSTOMER customer ON rental_timestamps."customer_id" = customer."customer_id"
JOIN PAGILA.PAGILA.ADDRESS address ON customer."address_id" = address."address_id"
JOIN PAGILA.PAGILA.CITY city ON address."city_id" = city."city_id"
JOIN PAGILA.PAGILA.INVENTORY inventory ON rental_timestamps."inventory_id" = inventory."inventory_id"
JOIN PAGILA.PAGILA.FILM_CATEGORY film_category ON inventory."film_id" = film_category."film_id"
JOIN PAGILA.PAGILA.CATEGORY category ON film_category."category_id" = category."category_id"
WHERE (city."city" LIKE 'A%' OR city."city" LIKE '%-%') 
  AND rental_timestamps."rental_ts" IS NOT NULL
  AND rental_timestamps."return_ts" IS NOT NULL
GROUP BY category."name"
ORDER BY "TotalRentalHours" DESC NULLS LAST
LIMIT 1;