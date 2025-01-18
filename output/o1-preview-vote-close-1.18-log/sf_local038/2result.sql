SELECT CONCAT(A."first_name", ' ', A."last_name") AS "Full_name"
FROM PAGILA.PAGILA.ACTOR A
JOIN PAGILA.PAGILA.FILM_ACTOR FA ON A."actor_id" = FA."actor_id"
JOIN PAGILA.PAGILA.FILM F ON FA."film_id" = F."film_id"
JOIN PAGILA.PAGILA.LANGUAGE L ON F."language_id" = L."language_id"
JOIN PAGILA.PAGILA.FILM_CATEGORY FC ON F."film_id" = FC."film_id"
JOIN PAGILA.PAGILA.CATEGORY C ON FC."category_id" = C."category_id"
WHERE F."release_year" BETWEEN '2000' AND '2010'
  AND F."length" <= 120
  AND F."rating" IN ('G', 'PG')
  AND L."name" = 'English'
  AND C."name" = 'Children'
GROUP BY A."actor_id", "Full_name"
ORDER BY COUNT(*) DESC NULLS LAST
LIMIT 1;