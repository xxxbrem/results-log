WITH questions_2021 AS (
    SELECT 
        "id" AS question_id,
        "creation_date" AS question_creation_date,
        EXTRACT(DAYOFWEEK FROM TO_TIMESTAMP("creation_date" / 1000000)) AS day_of_week
    FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
    WHERE "creation_date" BETWEEN 1609459200000000 AND 1640995199000000
),
answers AS (
    SELECT
        "parent_id" AS question_id,
        MIN("creation_date") AS first_answer_date
    FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS
    GROUP BY "parent_id"
),
questions_with_answers AS (
    SELECT 
        q.question_id,
        q.question_creation_date,
        q.day_of_week,
        a.first_answer_date,
        (a.first_answer_date - q.question_creation_date) / 1000000 AS time_to_answer_seconds
    FROM questions_2021 q
    LEFT JOIN answers a ON q.question_id = a.question_id
),
questions_answered_within_1h AS (
    SELECT
        day_of_week,
        COUNT(*) AS questions_answered_within_1h
    FROM questions_with_answers
    WHERE time_to_answer_seconds BETWEEN 0 AND 3600
    GROUP BY day_of_week
),
total_questions AS (
    SELECT
        day_of_week,
        COUNT(*) AS total_questions
    FROM questions_2021
    GROUP BY day_of_week
)
SELECT
    CASE day_of_week
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS Day_of_Week,
    total_questions AS Questions_Asked,
    COALESCE(questions_answered_within_1h, 0) AS Questions_Answered_within_1h,
    ROUND(COALESCE(questions_answered_within_1h * 100.0 / total_questions, 0), 4) AS Percentage_Answered_within_1h
FROM total_questions t
LEFT JOIN questions_answered_within_1h a USING (day_of_week)
ORDER BY day_of_week;