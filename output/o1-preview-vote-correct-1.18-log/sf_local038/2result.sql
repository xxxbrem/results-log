SELECT CONCAT(A."first_name", ' ', A."last_name") AS "Full_Name", COUNT(*) AS "Appearance_Count"
FROM PAGILA.PAGILA.ACTOR A
JOIN PAGILA.PAGILA.FILM_ACTOR FA ON A."actor_id" = FA."actor_id"
JOIN PAGILA.PAGILA.FILM F ON FA."film_id" = F."film_id"
JOIN PAGILA.PAGILA.LANGUAGE L ON F."language_id" = L."language_id"
JOIN PAGILA.PAGILA.FILM_CATEGORY FC ON F."film_id" = FC."film_id"
JOIN PAGILA.PAGILA.CATEGORY C ON FC."category_id" = C."category_id"
WHERE L."name" = 'English'
  AND F."rating" IN ('G', 'PG')
  AND C."name" = 'Children'
  AND F."length" <= 120
  AND F."release_year" BETWEEN '2000' AND '2010'
GROUP BY "Full_Name"
ORDER BY "Appearance_Count" DESC NULLS LAST
LIMIT 1;