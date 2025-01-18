WITH questions_2021 AS (
    SELECT
        q."id" AS "question_id",
        EXTRACT(DAYOFWEEK FROM TO_TIMESTAMP(q."creation_date" / 1000000)) AS "day_of_week",
        q."creation_date" AS "question_creation_date"
    FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS q
    WHERE q."creation_date" >= 1609459200000000 AND q."creation_date" < 1640995200000000
),
answers_within_1hr AS (
    SELECT DISTINCT
        a."parent_id" AS "question_id"
    FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS a
    JOIN questions_2021 q
        ON a."parent_id" = q."question_id"
    WHERE a."creation_date" - q."question_creation_date" BETWEEN 0 AND 3600000000
)
SELECT
    CASE 
        WHEN q."day_of_week" = 1 THEN 'Sunday'
        WHEN q."day_of_week" = 2 THEN 'Monday'
        WHEN q."day_of_week" = 3 THEN 'Tuesday'
        WHEN q."day_of_week" = 4 THEN 'Wednesday'
        WHEN q."day_of_week" = 5 THEN 'Thursday'
        WHEN q."day_of_week" = 6 THEN 'Friday'
        WHEN q."day_of_week" = 7 THEN 'Saturday'
    END AS "DayOfWeek",
    COUNT(*) AS "NumAsked",
    COUNT(a."question_id") AS "NumAnsweredIn1Hr",
    ROUND(COUNT(a."question_id") * 100.0 / COUNT(*), 4) AS "PercentageAnsweredIn1Hr"
FROM questions_2021 q
LEFT JOIN answers_within_1hr a
    ON q."question_id" = a."question_id"
WHERE q."day_of_week" IS NOT NULL
GROUP BY q."day_of_week"
ORDER BY q."day_of_week";