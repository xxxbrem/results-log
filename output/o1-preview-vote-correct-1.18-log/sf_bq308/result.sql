WITH questions_2021 AS (
    SELECT
        "id",
        "creation_date",
        TO_TIMESTAMP_NTZ("creation_date" / 1000000) AS ts_creation_date,
        DAYOFWEEKISO(TO_TIMESTAMP_NTZ("creation_date" / 1000000)) AS day_of_week_iso,
        DAYNAME(TO_TIMESTAMP_NTZ("creation_date" / 1000000)) AS day_of_week_name
    FROM
        STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
    WHERE
        "creation_date" BETWEEN 1609459200000000 AND 1640995199000000
),
answers_first_per_question AS (
    SELECT
        "parent_id" AS question_id,
        MIN("creation_date") AS first_answer_creation_date
    FROM
        STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS
    GROUP BY
        "parent_id"
),
questions_with_answer_info AS (
    SELECT
        q."id",
        q.day_of_week_iso,
        q.day_of_week_name,
        CASE
            WHEN a.first_answer_creation_date IS NOT NULL AND (a.first_answer_creation_date - q."creation_date") <= 3600 * 1000000 THEN 1
            ELSE 0
        END AS answered_within_one_hour
    FROM
        questions_2021 q
    LEFT JOIN
        answers_first_per_question a
    ON
        q."id" = a.question_id
)
SELECT
    qwai.day_of_week_name AS "DayOfWeek",
    COUNT(*) AS "NumQuestions",
    SUM(qwai.answered_within_one_hour) AS "NumAnsweredWithinOneHour",
    ROUND(SUM(qwai.answered_within_one_hour) * 100.0 / COUNT(*), 4) AS "PercentageAnsweredWithinOneHour"
FROM
    questions_with_answer_info qwai
GROUP BY
    qwai.day_of_week_iso,
    qwai.day_of_week_name
ORDER BY
    qwai.day_of_week_iso;