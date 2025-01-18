SELECT A."first_name" || ' ' || A."last_name" AS "Full_Name"
FROM PAGILA.PAGILA.ACTOR A
JOIN (
    SELECT FA."actor_id", COUNT(*) AS film_count
    FROM PAGILA.PAGILA.FILM_ACTOR FA
    JOIN PAGILA.PAGILA.FILM F ON FA."film_id" = F."film_id"
    JOIN PAGILA.PAGILA.FILM_CATEGORY FC ON F."film_id" = FC."film_id"
    WHERE F."language_id" = 1
      AND F."rating" IN ('G', 'PG')
      AND F."length" <= 120
      AND FC."category_id" = (SELECT "category_id" FROM PAGILA.PAGILA.CATEGORY WHERE "name" = 'Children')
      AND F."release_year" BETWEEN '2000' AND '2010'
    GROUP BY FA."actor_id"
    ORDER BY film_count DESC NULLS LAST
    LIMIT 1
) AS MostActed
ON A."actor_id" = MostActed."actor_id";