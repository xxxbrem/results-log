WITH actor_director_counts AS (
  SELECT c."PID" AS actor_PID, d."PID" AS director_PID, COUNT(*) AS movie_count
  FROM "DB_IMDB"."DB_IMDB"."M_CAST" c
  JOIN "DB_IMDB"."DB_IMDB"."M_DIRECTOR" d ON c."MID" = d."MID"
  GROUP BY c."PID", d."PID"
),
max_counts AS (
  SELECT actor_PID, MAX(movie_count) AS max_movie_count
  FROM actor_director_counts
  GROUP BY actor_PID
),
actor_top_directors AS (
  SELECT adc.actor_PID, adc.director_PID
  FROM actor_director_counts adc
  JOIN max_counts mc ON adc.actor_PID = mc.actor_PID AND adc.movie_count = mc.max_movie_count
),
unique_top_directors AS (
  SELECT actor_PID
  FROM actor_top_directors
  GROUP BY actor_PID
  HAVING COUNT(*) = 1
)
SELECT COUNT(DISTINCT atd.actor_PID) AS "Number_of_actors"
FROM actor_top_directors atd
JOIN unique_top_directors utd ON atd.actor_PID = utd.actor_PID
WHERE atd.director_PID = 'nm0007181';