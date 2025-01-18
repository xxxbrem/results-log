SELECT u."UserName", ur."UpvotesReceived", COALESCE(ug."UpvotesGiven", 0) AS "UpvotesGiven"
FROM
(
    SELECT "ToUserId" AS "UserId", COUNT(*) AS "UpvotesReceived"
    FROM "META_KAGGLE"."META_KAGGLE"."FORUMMESSAGEVOTES"
    GROUP BY "ToUserId"
) ur
LEFT JOIN
(
    SELECT "FromUserId" AS "UserId", COUNT(*) AS "UpvotesGiven"
    FROM "META_KAGGLE"."META_KAGGLE"."FORUMMESSAGEVOTES"
    GROUP BY "FromUserId"
) ug
ON ur."UserId" = ug."UserId"
INNER JOIN "META_KAGGLE"."META_KAGGLE"."USERS" u
ON u."Id" = ur."UserId"
ORDER BY ur."UpvotesReceived" DESC NULLS LAST
LIMIT 3;