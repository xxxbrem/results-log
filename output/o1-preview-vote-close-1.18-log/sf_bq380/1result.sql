WITH UpvotesReceived AS (
    SELECT v."ToUserId", COUNT(*) AS "UpvotesReceived"
    FROM META_KAGGLE.META_KAGGLE."FORUMMESSAGEVOTES" v
    GROUP BY v."ToUserId"
),
UpvotesGiven AS (
    SELECT v."FromUserId", COUNT(*) AS "UpvotesGivenToOthers"
    FROM META_KAGGLE.META_KAGGLE."FORUMMESSAGEVOTES" v
    GROUP BY v."FromUserId"
)
SELECT u."UserName",
       COALESCE(r."UpvotesReceived", 0) AS "UpvotesReceived",
       COALESCE(g."UpvotesGivenToOthers", 0) AS "UpvotesGivenToOthers"
FROM META_KAGGLE.META_KAGGLE."USERS" u
LEFT JOIN UpvotesReceived r ON u."Id" = r."ToUserId"
LEFT JOIN UpvotesGiven g ON u."Id" = g."FromUserId"
ORDER BY r."UpvotesReceived" DESC NULLS LAST
LIMIT 3;