WITH actor_director_counts AS (
    SELECT
        mc."PID" AS "Actor_PID",
        md."PID" AS "Director_PID",
        COUNT(DISTINCT mc."MID") AS "Film_Count"
    FROM
        "DB_IMDB"."DB_IMDB"."M_CAST" mc
    JOIN
        "DB_IMDB"."DB_IMDB"."M_DIRECTOR" md ON mc."MID" = md."MID"
    GROUP BY
        mc."PID", md."PID"
),
actor_yash_counts AS (
    SELECT
        "Actor_PID",
        "Film_Count" AS "Yash_Film_Count"
    FROM
        actor_director_counts
    WHERE
        "Director_PID" = 'nm0007181'
),
actor_other_max_counts AS (
    SELECT
        "Actor_PID",
        MAX("Film_Count") AS "Max_Other_Film_Count"
    FROM actor_director_counts
    WHERE
        "Director_PID" <> 'nm0007181'
    GROUP BY
        "Actor_PID"
)
SELECT COUNT(*) AS "Number_of_actors"
FROM actor_yash_counts ayc
LEFT JOIN actor_other_max_counts aomc ON ayc."Actor_PID" = aomc."Actor_PID"
WHERE ayc."Yash_Film_Count" > COALESCE(aomc."Max_Other_Film_Count", 0);