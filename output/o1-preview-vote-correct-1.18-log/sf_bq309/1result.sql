WITH user_badge_counts AS (
    SELECT
        "user_id",
        COUNT(*) AS "badge_count"
    FROM
        STACKOVERFLOW.STACKOVERFLOW."BADGES"
    GROUP BY
        "user_id"
),
answers_with_ratio AS (
    SELECT
        a."parent_id" AS "question_id",
        MAX(
            CASE
                WHEN (CAST(a."score" AS FLOAT) / NULLIF(q."view_count", 0)) > 0.01 THEN 1
                ELSE 0
            END
        ) AS "has_high_ratio_answer"
    FROM
        STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" AS a
    JOIN
        STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" AS q
            ON a."parent_id" = q."id"
    GROUP BY
        a."parent_id"
),
questions_with_data AS (
    SELECT
        q."id" AS "question_id",
        REPLACE(CAST(q."title" AS STRING), '"', '') AS "question_title",
        LENGTH(q."body") AS "question_body_length",
        q."owner_user_id",
        q."score" AS "net_votes",
        q."view_count",
        q."accepted_answer_id",
        u."reputation" AS "user_reputation",
        COALESCE(b."badge_count", 0) AS "badge_count"
    FROM
        STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" AS q
    LEFT JOIN
        STACKOVERFLOW.STACKOVERFLOW."USERS" AS u
            ON q."owner_user_id" = u."id"
    LEFT JOIN
        user_badge_counts AS b
            ON q."owner_user_id" = b."user_id"
)
SELECT
    q."question_id",
    q."question_title",
    q."question_body_length",
    q."user_reputation",
    q."net_votes",
    q."badge_count"
FROM
    questions_with_data AS q
LEFT JOIN
    answers_with_ratio AS a
    ON q."question_id" = a."question_id"
WHERE
    q."accepted_answer_id" IS NOT NULL
    OR a."has_high_ratio_answer" = 1
ORDER BY
    q."question_body_length" DESC NULLS LAST,
    q."question_id"
LIMIT 10;