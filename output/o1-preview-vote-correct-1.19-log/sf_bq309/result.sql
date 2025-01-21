SELECT q."id" AS "Question_id",
       CAST(q."title" AS STRING) AS "Title",
       LENGTH(COALESCE(q."body", '')) AS "Question_length",
       COALESCE(u."reputation", 0) AS "User_reputation",
       q."score" AS "Net_votes",
       COALESCE(b."badge_count", 0) AS "Badge_count"
FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
LEFT JOIN (
    SELECT "parent_id" AS "question_id",
           MAX("score") AS "max_answer_score"
    FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS"
    GROUP BY "parent_id"
) ar
    ON q."id" = ar."question_id"
LEFT JOIN STACKOVERFLOW.STACKOVERFLOW."USERS" u
    ON q."owner_user_id" = u."id"
LEFT JOIN (
    SELECT "user_id", COUNT(*) AS "badge_count"
    FROM STACKOVERFLOW.STACKOVERFLOW."BADGES"
    GROUP BY "user_id"
) b
    ON u."id" = b."user_id"
WHERE q."accepted_answer_id" IS NOT NULL
   OR (ar."max_answer_score" IS NOT NULL AND q."view_count" > 0 AND (ar."max_answer_score" / NULLIF(q."view_count", 0)) > 0.01)
ORDER BY LENGTH(COALESCE(q."body", '')) DESC NULLS LAST, q."id" ASC
LIMIT 10;