SELECT TOP 10
    pq."id" AS "Question_ID",
    pq."title" AS "Title",
    LENGTH(CAST(pq."body" AS STRING)) AS "Question_Length",
    COALESCE(u."reputation", 0) AS "User_Reputation",
    COALESCE(pq."score", 0) AS "Net_Votes",
    COALESCE(bc."Badge_Count", 0) AS "Badge_Count"
FROM
    STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" pq
LEFT JOIN
    STACKOVERFLOW.STACKOVERFLOW."USERS" u
    ON pq."owner_user_id" = u."id"
LEFT JOIN
    (
        SELECT "user_id", COUNT(*) AS "Badge_Count"
        FROM STACKOVERFLOW.STACKOVERFLOW."BADGES"
        WHERE "user_id" IS NOT NULL
        GROUP BY "user_id"
    ) bc
    ON u."id" = bc."user_id"
LEFT JOIN
    (
        SELECT
            pa."parent_id" AS "Question_ID",
            MAX(pa."score") / NULLIF(pq2."view_count", 0) AS "Max_Score_View_Ratio"
        FROM
            STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" pa
        JOIN
            STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" pq2
            ON pa."parent_id" = pq2."id"
        WHERE
            pq2."view_count" > 0
            AND pa."score" IS NOT NULL
        GROUP BY
            pa."parent_id", pq2."view_count"
    ) ar
    ON pq."id" = ar."Question_ID"
WHERE
    pq."view_count" > 0
    AND (
        pq."accepted_answer_id" IS NOT NULL
        OR COALESCE(ar."Max_Score_View_Ratio", 0) > 0.01
    )
ORDER BY
    LENGTH(CAST(pq."body" AS STRING)) DESC NULLS LAST;