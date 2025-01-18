WITH question_answer_data AS (
    SELECT
        q."id" AS "question_id",
        TO_TIMESTAMP(q."creation_date" / 1000000) AS "question_creation_ts",
        DAYNAME(TO_TIMESTAMP(q."creation_date" / 1000000)) AS "Day_of_week",
        MIN(TO_TIMESTAMP(a."creation_date" / 1000000)) AS "first_answer_creation_ts"
    FROM
        STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
    LEFT JOIN
        STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" a ON q."id" = a."parent_id"
    GROUP BY
        q."id", q."creation_date"
)
SELECT
    "Day_of_week",
    ROUND(
        SUM(
            CASE
                WHEN "first_answer_creation_ts" IS NOT NULL
                 AND TIMESTAMPDIFF('second', "question_creation_ts", "first_answer_creation_ts") <= 3600
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        4
    ) AS "Percentage_answered_within_an_hour"
FROM
    question_answer_data
GROUP BY
    "Day_of_week"
ORDER BY
    "Percentage_answered_within_an_hour" DESC NULLS LAST
LIMIT 1 OFFSET 2;