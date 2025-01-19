WITH YashCollaborations AS (
    SELECT
        MC."PID" AS "Actor_PID",
        COUNT(*) AS "YashCount"
    FROM
        "DB_IMDB"."DB_IMDB"."M_CAST" MC
        INNER JOIN "DB_IMDB"."DB_IMDB"."M_DIRECTOR" MD ON MC."MID" = MD."MID"
    WHERE
        MD."PID" = 'nm0007181'
    GROUP BY
        MC."PID"
),
MaxCollaborations AS (
    SELECT
        "Actor_PID",
        COALESCE(MAX("CollaborationCount"), 0) AS "MaxCollaborationCount"
    FROM
        (
            SELECT
                MC."PID" AS "Actor_PID",
                MD."PID" AS "Director_PID",
                COUNT(*) AS "CollaborationCount"
            FROM
                "DB_IMDB"."DB_IMDB"."M_CAST" MC
                INNER JOIN "DB_IMDB"."DB_IMDB"."M_DIRECTOR" MD ON MC."MID" = MD."MID"
            WHERE
                MD."PID" <> 'nm0007181'  -- Exclude Yash Chopra
            GROUP BY
                MC."PID",
                MD."PID"
        ) AS Collaborations
    GROUP BY
        "Actor_PID"
)
SELECT
    COUNT(*) AS "number_of_actors"
FROM
    YashCollaborations Y
    LEFT JOIN MaxCollaborations M ON Y."Actor_PID" = M."Actor_PID"
WHERE
    Y."YashCount" > COALESCE(M."MaxCollaborationCount", 0);