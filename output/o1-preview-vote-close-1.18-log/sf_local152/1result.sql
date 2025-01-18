WITH director_movies AS (
  SELECT
    D."name_id",
    N."name" AS "director_name",
    D."movie_id",
    CAST(M."date_published" AS DATE) AS "date_published",
    M."duration",
    R."avg_rating",
    R."total_votes"
  FROM "IMDB_MOVIES"."IMDB_MOVIES"."DIRECTOR_MAPPING" D
  JOIN "IMDB_MOVIES"."IMDB_MOVIES"."NAMES" N ON D."name_id" = N."id"
  JOIN "IMDB_MOVIES"."IMDB_MOVIES"."MOVIES" M ON D."movie_id" = M."id"
  LEFT JOIN "IMDB_MOVIES"."IMDB_MOVIES"."RATINGS" R ON M."id" = R."movie_id"
  WHERE M."date_published" IS NOT NULL AND M."duration" IS NOT NULL
),
director_movies_with_diffs AS (
  SELECT
    dm.*,
    LAG(dm."date_published") OVER (
       PARTITION BY dm."name_id" 
       ORDER BY dm."date_published"
    ) AS "prev_date_published"
  FROM director_movies dm
),
director_movies_with_intervals AS (
  SELECT
    dmwd.*,
    DATEDIFF('day', dmwd."prev_date_published", dmwd."date_published") AS "inter_movie_duration"
  FROM director_movies_with_diffs dmwd
),
director_aggregates AS (
  SELECT
    "name_id",
    "director_name",
    COUNT(*) AS "number_of_movies",
    SUM("duration") AS "total_movie_duration",
    CASE WHEN COUNT(*) > 1 THEN ROUND(AVG("inter_movie_duration"), 0) ELSE 0 END AS "average_inter_movie_duration",
    ROUND(AVG("avg_rating"), 4) AS "average_rating",
    SUM("total_votes") AS "total_votes",
    MIN("avg_rating") AS "minimum_rating",
    MAX("avg_rating") AS "maximum_rating"
  FROM director_movies_with_intervals
  GROUP BY "name_id", "director_name"
),
top_directors AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      ORDER BY "number_of_movies" DESC NULLS LAST, "total_movie_duration" DESC NULLS LAST
    ) AS "rank"
  FROM director_aggregates
)
SELECT
  "name_id" AS "director_id",
  "director_name",
  "number_of_movies",
  "average_inter_movie_duration",
  "average_rating",
  "total_votes",
  "minimum_rating",
  "maximum_rating",
  "total_movie_duration"
FROM top_directors
WHERE "rank" <= 9
ORDER BY "number_of_movies" DESC NULLS LAST, "total_movie_duration" DESC NULLS LAST;