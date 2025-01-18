WITH DirectorMovies AS (
    SELECT
        NAMES."id" AS "director_id",
        NAMES."name" AS "name",
        MOVIES."id" AS "movie_id",
        CAST(MOVIES."date_published" AS DATE) AS "date_published",
        MOVIES."duration" AS "duration",
        RATINGS."avg_rating" AS "avg_rating",
        RATINGS."total_votes" AS "total_votes"
    FROM
        IMDB_MOVIES.IMDB_MOVIES."DIRECTOR_MAPPING" AS DIR_MAP
        JOIN IMDB_MOVIES.IMDB_MOVIES."NAMES" AS NAMES ON DIR_MAP."name_id" = NAMES."id"
        JOIN IMDB_MOVIES.IMDB_MOVIES."MOVIES" AS MOVIES ON DIR_MAP."movie_id" = MOVIES."id"
        LEFT JOIN IMDB_MOVIES.IMDB_MOVIES."RATINGS" AS RATINGS ON MOVIES."id" = RATINGS."movie_id"
    WHERE
        MOVIES."date_published" IS NOT NULL
        AND MOVIES."duration" IS NOT NULL
        AND RATINGS."avg_rating" IS NOT NULL
        AND RATINGS."total_votes" IS NOT NULL
),
DirectorMoviesLag AS (
    SELECT
        "director_id",
        "name",
        "movie_id",
        "date_published",
        "duration",
        "avg_rating",
        "total_votes",
        LAG("date_published") OVER (PARTITION BY "director_id" ORDER BY "date_published") AS "prev_date_published"
    FROM DirectorMovies
),
DirectorMovieIntervals AS (
    SELECT
        "director_id",
        "name",
        "movie_id",
        "date_published",
        "duration",
        "avg_rating",
        "total_votes",
        DATEDIFF('day', "prev_date_published", "date_published") AS "inter_movie_duration"
    FROM DirectorMoviesLag
)
SELECT
    "director_id",
    "name",
    COUNT(*) AS "number_of_movies",
    ROUND(AVG("inter_movie_duration")) AS "average_inter_movie_duration",
    ROUND(AVG("avg_rating"), 2) AS "average_rating",
    SUM("total_votes") AS "total_votes",
    MIN("avg_rating") AS "minimum_rating",
    MAX("avg_rating") AS "maximum_rating",
    SUM("duration") AS "total_movie_duration"
FROM
    DirectorMovieIntervals
GROUP BY
    "director_id",
    "name"
ORDER BY
    "number_of_movies" DESC NULLS LAST,
    "total_movie_duration" DESC NULLS LAST
LIMIT 9;