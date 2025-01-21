SELECT
    q."id" AS "Question_id",
    q."title" AS "Title",
    LENGTH(q."body") AS "Question_length",
    u."reputation" AS "User_reputation",
    q."score" AS "Net_votes",
    COALESCE(b."badge_count", 0) AS "Badge_count"
FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" q
LEFT JOIN "STACKOVERFLOW"."STACKOVERFLOW"."USERS" u ON q."owner_user_id" = u."id"
LEFT JOIN (
    SELECT "user_id", COUNT(*) AS "badge_count"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."BADGES"
    GROUP BY "user_id"
) b ON q."owner_user_id" = b."user_id"
LEFT JOIN (
    SELECT
        "parent_id",
        MAX("score") AS "max_answer_score"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS"
    GROUP BY "parent_id"
) a ON q."id" = a."parent_id"
WHERE
    q."accepted_answer_id" IS NOT NULL
    OR (a."max_answer_score" / NULLIF(q."view_count", 0) > 0.01)
ORDER BY LENGTH(q."body") DESC NULLS LAST
LIMIT 10;