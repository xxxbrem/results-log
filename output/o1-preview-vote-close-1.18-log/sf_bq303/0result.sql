WITH post_to_question AS (
    -- Map each post_id to its question_id
    SELECT q."id" AS "post_id", q."id" AS "question_id"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" q
    UNION ALL
    SELECT a."id" AS "post_id", a."parent_id" AS "question_id"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" a
),
comments_with_question AS (
    -- Get comments with associated question_id
    SELECT c."user_id", c."post_id", p2q."question_id", TO_TIMESTAMP(c."creation_date" / 1000000) AS "creation_date"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."COMMENTS" c
    INNER JOIN post_to_question p2q ON c."post_id" = p2q."post_id"
),
all_posts AS (
    -- Combine questions, answers, and comments with question_id
    SELECT q."id" AS "post_id", q."owner_user_id" AS "user_id", q."id" AS "question_id", TO_TIMESTAMP(q."creation_date" / 1000000) AS "creation_date"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" q
    UNION ALL
    SELECT a."id" AS "post_id", a."owner_user_id" AS "user_id", a."parent_id" AS "question_id", TO_TIMESTAMP(a."creation_date" / 1000000) AS "creation_date"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" a
    UNION ALL
    SELECT c."post_id", c."user_id" AS "user_id", c."question_id", c."creation_date"
    FROM comments_with_question c
),
post_question_tags AS (
    -- Join all posts with their question's tags
    SELECT p."user_id", t."tags", p."creation_date"
    FROM all_posts p
    LEFT JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" t ON p."question_id" = t."id"
)
SELECT pqt."user_id", pqt."tags"
FROM post_question_tags pqt
WHERE pqt."user_id" BETWEEN 16712208 AND 18712208
  AND pqt."creation_date" BETWEEN TIMESTAMP '2019-07-01 00:00:00' AND TIMESTAMP '2019-12-31 23:59:59';