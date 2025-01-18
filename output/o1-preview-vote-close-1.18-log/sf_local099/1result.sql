SELECT COUNT(*) AS "number_of_actors"
FROM (
    SELECT
        actor_pid,
        MAX(CASE WHEN director_pid = 'nm0007181' THEN num_films_together ELSE 0 END) AS yash_num_films,
        COALESCE(MAX(CASE WHEN director_pid <> 'nm0007181' THEN num_films_together END), 0) AS max_films_with_others
    FROM (
        SELECT
            mc."PID" AS actor_pid,
            md."PID" AS director_pid,
            COUNT(*) AS num_films_together
        FROM
            "DB_IMDB"."DB_IMDB"."M_CAST" mc
            JOIN "DB_IMDB"."DB_IMDB"."M_DIRECTOR" md ON mc."MID" = md."MID"
        GROUP BY
            mc."PID",
            md."PID"
    ) AS actor_director_counts
    GROUP BY
        actor_pid
) AS films_per_actor
WHERE yash_num_films > max_films_with_others;