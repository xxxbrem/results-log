SELECT
    TO_TIMESTAMP_NTZ(ft."CreationDate" / 1e6) AS "CreationDate",
    ft."Title",
    f."Title" AS "ParentForum",
    COALESCE(ft."TotalReplies", 0) AS "ReplyCount",
    COALESCE(du."DistinctUserCount", 0) AS "DistinctUserCount",
    COALESCE(uv."Upvotes", 0) AS "Upvotes",
    COALESCE(ft."TotalViews", 0) AS "TotalViews"
FROM "META_KAGGLE"."META_KAGGLE"."FORUMTOPICS" ft
JOIN "META_KAGGLE"."META_KAGGLE"."FORUMS" f
    ON ft."ForumId" = f."Id"
LEFT JOIN (
    SELECT
        fm."ForumTopicId",
        COUNT(DISTINCT fm."PostUserId") AS "DistinctUserCount"
    FROM "META_KAGGLE"."META_KAGGLE"."FORUMMESSAGES" fm
    GROUP BY fm."ForumTopicId"
) du
    ON ft."Id" = du."ForumTopicId"
LEFT JOIN (
    SELECT
        fm."ForumTopicId",
        COUNT(*) AS "Upvotes"
    FROM "META_KAGGLE"."META_KAGGLE"."FORUMMESSAGES" fm
    JOIN "META_KAGGLE"."META_KAGGLE"."FORUMMESSAGEVOTES" fmv
        ON fm."Id" = fmv."ForumMessageId"
    GROUP BY fm."ForumTopicId"
) uv
    ON ft."Id" = uv."ForumTopicId"
WHERE LOWER(f."Title") = 'general'
ORDER BY ft."CreationDate" ASC
LIMIT 5;