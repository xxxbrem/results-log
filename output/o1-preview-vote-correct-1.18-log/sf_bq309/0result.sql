WITH questions_with_high_ratio AS (
    SELECT DISTINCT
        a."parent_id" AS "question_id"
    FROM
        "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" a
    INNER JOIN
        "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" q
        ON a."parent_id" = q."id"
    WHERE
        q."view_count" > 0
        AND (a."score" / q."view_count") > 0.01
)

SELECT
    CAST(q."title" AS STRING) AS "question_title",
    LENGTH(q."body") AS "body_length",
    u."reputation" AS "user_reputation",
    q."score" AS "net_votes",
    COALESCE(b."badge_count", 0) AS "badge_count"
FROM
    "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" q
LEFT JOIN
    "STACKOVERFLOW"."STACKOVERFLOW"."USERS" u
    ON q."owner_user_id" = u."id"
LEFT JOIN (
    SELECT
        ba."user_id",
        COUNT(*) AS "badge_count"
    FROM
        "STACKOVERFLOW"."STACKOVERFLOW"."BADGES" ba
    GROUP BY
        ba."user_id"
) b
    ON u."id" = b."user_id"
LEFT JOIN
    questions_with_high_ratio qr
    ON q."id" = qr."question_id"
WHERE
    q."accepted_answer_id" IS NOT NULL
    OR qr."question_id" IS NOT NULL
ORDER BY
    LENGTH(q."body") DESC NULLS LAST,
    q."creation_date" DESC NULLS LAST
LIMIT 10;