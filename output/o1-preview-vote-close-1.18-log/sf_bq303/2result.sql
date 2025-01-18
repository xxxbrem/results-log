WITH all_user_tags AS (
    SELECT "owner_user_id" AS "user_id", "tags", "creation_date" 
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS"
    UNION ALL
    SELECT pa."owner_user_id" AS "user_id", pq."tags", pa."creation_date"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" pa
    INNER JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" pq ON pa."parent_id" = pq."id"
    UNION ALL
    SELECT c."user_id", COALESCE(pq."tags", pq2."tags") AS "tags", c."creation_date"
    FROM "STACKOVERFLOW"."STACKOVERFLOW"."COMMENTS" c
    LEFT JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" pq ON c."post_id" = pq."id"
    LEFT JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" pa ON c."post_id" = pa."id"
    LEFT JOIN "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" pq2 ON pa."parent_id" = pq2."id"
)
SELECT
    "user_id",
    "tags"
FROM
    all_user_tags
WHERE
    "user_id" BETWEEN 16712208 AND 18712208
    AND "creation_date" BETWEEN 1561939200000000 AND 1577836799000000;