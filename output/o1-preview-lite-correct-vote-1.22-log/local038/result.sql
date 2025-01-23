SELECT a."first_name" || ' ' || a."last_name" AS Full_name
FROM "actor" a
JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
JOIN "film" f ON fa."film_id" = f."film_id"
JOIN "language" l ON f."language_id" = l."language_id"
WHERE l."name" = 'English'
  AND f."rating" IN ('G', 'PG')
  AND f."length" <= 120
  AND f."release_year" BETWEEN '2000' AND '2010'
GROUP BY a."actor_id", a."first_name", a."last_name"
ORDER BY COUNT(*) DESC
LIMIT 1;