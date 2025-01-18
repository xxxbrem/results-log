WITH Received AS (
    SELECT
        "ToUserId" AS "UserId",
        COUNT(*) AS "UpvotesReceived"
    FROM META_KAGGLE.META_KAGGLE.FORUMMESSAGEVOTES
    GROUP BY "ToUserId"
),
Given AS (
    SELECT
        "FromUserId" AS "UserId",
        COUNT(*) AS "UpvotesGiven"
    FROM META_KAGGLE.META_KAGGLE.FORUMMESSAGEVOTES
    GROUP BY "FromUserId"
)
SELECT
    u."UserName",
    COALESCE(r."UpvotesReceived", 0) AS "UpvotesReceived",
    COALESCE(g."UpvotesGiven", 0) AS "UpvotesGiven"
FROM META_KAGGLE.META_KAGGLE.USERS u
LEFT JOIN Received r ON u."Id" = r."UserId"
LEFT JOIN Given g ON u."Id" = g."UserId"
ORDER BY "UpvotesReceived" DESC NULLS LAST
LIMIT 3;