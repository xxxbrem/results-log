WITH question_answers AS (
    SELECT
        q."id" AS question_id,
        DAYOFWEEK(TO_TIMESTAMP(q."creation_date" / 1000000)) AS day_of_week,
        q."creation_date" AS question_creation_date,
        MIN(a."creation_date") AS first_answer_creation_date
    FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
    LEFT JOIN STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" a
      ON q."id" = a."parent_id"
    WHERE q."creation_date" IS NOT NULL
    GROUP BY q."id", day_of_week, q."creation_date"
),
questions_within_hour AS (
    SELECT
        day_of_week,
        COUNT(*) AS total_questions,
        COUNT(CASE
            WHEN first_answer_creation_date IS NOT NULL
             AND first_answer_creation_date >= question_creation_date
             AND (first_answer_creation_date - question_creation_date) / 1000000 BETWEEN 0 AND 3600
            THEN 1
            ELSE NULL
            END) AS answered_within_hour
    FROM question_answers
    GROUP BY day_of_week
),
percentages AS (
    SELECT
        day_of_week,
        (answered_within_hour::float / total_questions) * 100 AS percentage
    FROM questions_within_hour
)
SELECT
    CASE
        WHEN day_of_week = 1 THEN 'Sunday'
        WHEN day_of_week = 2 THEN 'Monday'
        WHEN day_of_week = 3 THEN 'Tuesday'
        WHEN day_of_week = 4 THEN 'Wednesday'
        WHEN day_of_week = 5 THEN 'Thursday'
        WHEN day_of_week = 6 THEN 'Friday'
        WHEN day_of_week = 7 THEN 'Saturday'
    END AS Day,
    ROUND(percentage, 4) AS Percentage
FROM percentages
ORDER BY percentage DESC NULLS LAST
LIMIT 1 OFFSET 2;