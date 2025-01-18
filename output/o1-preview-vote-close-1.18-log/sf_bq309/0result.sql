WITH AcceptedQuestions AS (
    SELECT PQ."id"
    FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS PQ
    WHERE PQ."accepted_answer_id" IS NOT NULL
),
HighScoreQuestions AS (
    SELECT DISTINCT PQ."id"
    FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS PQ
    JOIN STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS A ON A."parent_id" = PQ."id"
    WHERE PQ."view_count" > 0 AND (A."score" / PQ."view_count") > 0.01
),
EligibleQuestions AS (
    SELECT "id" FROM AcceptedQuestions
    UNION
    SELECT "id" FROM HighScoreQuestions
)
SELECT
    PQ."id" AS "Question_ID",
    PQ."title" AS "Title",
    LENGTH(PQ."body") AS "Question_Length",
    U."reputation" AS "User_Reputation",
    (U."up_votes" - U."down_votes") AS "Net_Votes",
    COALESCE(B."Badge_Count", 0) AS "Badge_Count"
FROM
    EligibleQuestions EQ
JOIN STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS PQ ON PQ."id" = EQ."id"
LEFT JOIN STACKOVERFLOW.STACKOVERFLOW.USERS U ON PQ."owner_user_id" = U."id"
LEFT JOIN (
    SELECT "user_id", COUNT(*) AS "Badge_Count"
    FROM STACKOVERFLOW.STACKOVERFLOW.BADGES
    GROUP BY "user_id"
) B ON PQ."owner_user_id" = B."user_id"
ORDER BY
    LENGTH(PQ."body") DESC NULLS LAST
LIMIT 10;