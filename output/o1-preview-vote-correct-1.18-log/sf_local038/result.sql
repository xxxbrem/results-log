SELECT CONCAT(a."first_name", ' ', a."last_name") AS "Full_Name"
FROM "PAGILA"."PAGILA"."ACTOR" a
JOIN "PAGILA"."PAGILA"."FILM_ACTOR" fa ON fa."actor_id" = a."actor_id"
JOIN "PAGILA"."PAGILA"."FILM" f ON f."film_id" = fa."film_id"
JOIN "PAGILA"."PAGILA"."FILM_CATEGORY" fc ON fc."film_id" = f."film_id"
JOIN "PAGILA"."PAGILA"."CATEGORY" c ON c."category_id" = fc."category_id"
WHERE f."language_id" = 1
  AND f."rating" IN ('G', 'PG')
  AND f."length" <= 120
  AND f."release_year" BETWEEN '2000' AND '2010'
  AND c."name" = 'Children'
GROUP BY a."actor_id", a."first_name", a."last_name"
ORDER BY COUNT(*) DESC NULLS LAST, a."actor_id" ASC
LIMIT 1;