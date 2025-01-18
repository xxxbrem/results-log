WITH EligibleFilms AS (
    SELECT F."film_id"
    FROM PAGILA.PAGILA."FILM" F
    JOIN PAGILA.PAGILA."LANGUAGE" L ON F."language_id" = L."language_id"
    JOIN PAGILA.PAGILA."FILM_CATEGORY" FC ON F."film_id" = FC."film_id"
    JOIN PAGILA.PAGILA."CATEGORY" C ON FC."category_id" = C."category_id"
    WHERE
        L."name" = 'English'
        AND F."rating" IN ('G', 'PG')
        AND C."name" = 'Children'
        AND F."length" <= 120
        AND F."release_year" BETWEEN 2000 AND 2010
)
SELECT
    A."first_name" || ' ' || A."last_name" AS "Name"
FROM EligibleFilms EF
JOIN PAGILA.PAGILA."FILM_ACTOR" FA ON EF."film_id" = FA."film_id"
JOIN PAGILA.PAGILA."ACTOR" A ON FA."actor_id" = A."actor_id"
GROUP BY A."actor_id", A."first_name", A."last_name"
ORDER BY COUNT(*) DESC NULLS LAST
LIMIT 1;