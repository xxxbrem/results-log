SELECT
    dmwl."name_id" AS "director_id",
    n."name" AS "director_name",
    COUNT(DISTINCT dmwl."movie_id") AS "movie_count",
    ROUND(AVG(dmwl."inter_movie_duration"), 0) AS "average_inter_movie_duration",
    ROUND(AVG(dmwl."avg_rating"), 4) AS "average_rating",
    SUM(COALESCE(dmwl."total_votes", 0)) AS "total_votes",
    ROUND(MIN(dmwl."avg_rating"), 4) AS "min_rating",
    ROUND(MAX(dmwl."avg_rating"), 4) AS "max_rating",
    SUM(COALESCE(dmwl."duration", 0)) AS "total_movie_duration"
FROM (
    SELECT
        dm."name_id",
        dm."movie_id",
        dm."year",
        dm."duration",
        dm."avg_rating",
        dm."total_votes",
        LAG(dm."year") OVER (PARTITION BY dm."name_id" ORDER BY dm."year") AS "previous_year",
        (dm."year" - LAG(dm."year") OVER (PARTITION BY dm."name_id" ORDER BY dm."year")) AS "inter_movie_duration"
    FROM (
        SELECT
            d."name_id",
            d."movie_id",
            m."year",
            m."duration",
            r."avg_rating",
            r."total_votes"
        FROM
            "IMDB_MOVIES"."IMDB_MOVIES"."DIRECTOR_MAPPING" d
            JOIN "IMDB_MOVIES"."IMDB_MOVIES"."MOVIES" m ON d."movie_id" = m."id"
            LEFT JOIN "IMDB_MOVIES"."IMDB_MOVIES"."RATINGS" r ON m."id" = r."movie_id"
        WHERE m."year" IS NOT NULL
    ) dm
) dmwl
JOIN "IMDB_MOVIES"."IMDB_MOVIES"."NAMES" n ON dmwl."name_id" = n."id"
GROUP BY dmwl."name_id", n."name"
ORDER BY COUNT(DISTINCT dmwl."movie_id") DESC NULLS LAST, SUM(COALESCE(dmwl."duration", 0)) DESC NULLS LAST
LIMIT 9;