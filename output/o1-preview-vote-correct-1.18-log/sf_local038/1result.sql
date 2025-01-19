SELECT CONCAT(A."first_name", ' ', A."last_name") AS "name"
FROM "PAGILA"."PAGILA"."ACTOR" A
JOIN (
    SELECT FA."actor_id", COUNT(*) AS "appearance_count"
    FROM "PAGILA"."PAGILA"."FILM_ACTOR" FA
    JOIN "PAGILA"."PAGILA"."FILM" F ON FA."film_id" = F."film_id"
    WHERE F."language_id" = 1
      AND F."rating" IN ('G', 'PG')
      AND F."length" <= 120
      AND TRY_CAST(F."release_year" AS INTEGER) BETWEEN 2000 AND 2010
    GROUP BY FA."actor_id"
    ORDER BY "appearance_count" DESC NULLS LAST
    LIMIT 1
) AS TopActor ON A."actor_id" = TopActor."actor_id";