SELECT COUNT(*) AS "number_of_actors"
FROM (
    WITH actor_director_counts AS (
        SELECT M_CAST."PID" AS "actor_pid", M_DIRECTOR."PID" AS "director_pid", COUNT(*) AS "movie_count"
        FROM "DB_IMDB"."DB_IMDB"."M_CAST" AS M_CAST
        JOIN "DB_IMDB"."DB_IMDB"."M_DIRECTOR" AS M_DIRECTOR ON M_CAST."MID" = M_DIRECTOR."MID"
        GROUP BY M_CAST."PID", M_DIRECTOR."PID"
    ),
    max_actor_collabs AS (
        SELECT "actor_pid", MAX("movie_count") AS "max_collab"
        FROM actor_director_counts
        GROUP BY "actor_pid"
    ),
    actors_with_yash_max AS (
        SELECT a."actor_pid"
        FROM max_actor_collabs a
        JOIN actor_director_counts c ON a."actor_pid" = c."actor_pid" AND a."max_collab" = c."movie_count"
        WHERE c."director_pid" = 'nm0007181'
    )
    SELECT * FROM actors_with_yash_max
);