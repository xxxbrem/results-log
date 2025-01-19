WITH actor_directors AS (
    SELECT mc."PID" AS actor_PID, md."PID" AS director_PID, COUNT(*) AS movie_count
    FROM "M_Cast" AS mc
    JOIN "M_Director" AS md ON mc."MID" = md."MID"
    GROUP BY mc."PID", md."PID"
),
yash_counts AS (
    SELECT actor_PID, movie_count AS yash_count
    FROM actor_directors
    WHERE director_PID = 'nm0007181'
),
max_other_counts AS (
    SELECT actor_PID, MAX(movie_count) AS max_other_movies
    FROM actor_directors
    WHERE director_PID != 'nm0007181'
    GROUP BY actor_PID
)
SELECT COUNT(*) AS Number_of_actors
FROM yash_counts y
LEFT JOIN max_other_counts m ON y.actor_PID = m.actor_PID
WHERE y.yash_count > IFNULL(m.max_other_movies, 0);