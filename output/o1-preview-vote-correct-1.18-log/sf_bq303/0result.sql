SELECT DISTINCT T."user_id", T."tags"
FROM (
    -- Select user IDs and tags from questions
    SELECT q."owner_user_id" AS "user_id", q."tags"
    FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
    WHERE q."owner_user_id" BETWEEN 16712208 AND 18712208
      AND q."creation_date" BETWEEN 1561939200000000 AND 1577750400000000

    UNION ALL

    -- Select user IDs and tags from answers
    SELECT a."owner_user_id" AS "user_id", q."tags"
    FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" a
    JOIN STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
      ON a."parent_id" = q."id"
    WHERE a."owner_user_id" BETWEEN 16712208 AND 18712208
      AND a."creation_date" BETWEEN 1561939200000000 AND 1577750400000000

    UNION ALL

    -- Select user IDs and tags from comments on questions
    SELECT c."user_id", q."tags"
    FROM STACKOVERFLOW.STACKOVERFLOW."COMMENTS" c
    JOIN STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
      ON c."post_id" = q."id"
    WHERE c."user_id" BETWEEN 16712208 AND 18712208
      AND c."creation_date" BETWEEN 1561939200000000 AND 1577750400000000

    UNION ALL

    -- Select user IDs and tags from comments on answers
    SELECT c."user_id", q."tags"
    FROM STACKOVERFLOW.STACKOVERFLOW."COMMENTS" c
    JOIN STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" a
      ON c."post_id" = a."id"
    JOIN STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
      ON a."parent_id" = q."id"
    WHERE c."user_id" BETWEEN 16712208 AND 18712208
      AND c."creation_date" BETWEEN 1561939200000000 AND 1577750400000000
) AS T;