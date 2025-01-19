SELECT DISTINCT combined."user_id", combined."tags"
FROM (
    -- Get tags from comments on questions
    SELECT c."user_id", pq."tags"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."COMMENTS" c
    INNER JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" pq
        ON c."post_id" = pq."id"
    WHERE c."user_id" BETWEEN 16712208 AND 18712208
        AND c."creation_date" BETWEEN 1561939200000000 AND 1577836799000000

    UNION ALL

    -- Get tags from comments on answers
    SELECT c."user_id", pq."tags"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."COMMENTS" c
    INNER JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" pa
        ON c."post_id" = pa."id"
    INNER JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" pq
        ON pa."parent_id" = pq."id"
    WHERE c."user_id" BETWEEN 16712208 AND 18712208
        AND c."creation_date" BETWEEN 1561939200000000 AND 1577836799000000

    UNION ALL

    -- Get tags from answers
    SELECT pa."owner_user_id" AS "user_id", pq."tags"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" pa
    INNER JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" pq
        ON pa."parent_id" = pq."id"
    WHERE pa."owner_user_id" BETWEEN 16712208 AND 18712208
        AND pa."creation_date" BETWEEN 1561939200000000 AND 1577836799000000

    UNION ALL

    -- Get tags from questions
    SELECT pq."owner_user_id" AS "user_id", pq."tags"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" pq
    WHERE pq."owner_user_id" BETWEEN 16712208 AND 18712208
        AND pq."creation_date" BETWEEN 1561939200000000 AND 1577836799000000
) AS combined
WHERE combined."tags" IS NOT NULL;