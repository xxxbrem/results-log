WITH Badges_CTE AS (
  SELECT "user_id", COUNT(*) AS "badge_count"
  FROM STACKOVERFLOW.STACKOVERFLOW."BADGES"
  GROUP BY "user_id"
),
HighScoreQuestions_CTE AS (
  SELECT DISTINCT q."id" AS "question_id"
  FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" a
  JOIN STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
    ON a."parent_id" = q."id"
  WHERE (a."score"::FLOAT / NULLIF(q."view_count", 0)) > 0.01
)
SELECT q."id" AS "Question_ID",
       LENGTH(q."body") AS "Length",
       u."reputation" AS "User_Reputation",
       q."score" AS "Net_Votes",
       COALESCE(bc."badge_count", 0) AS "Badge_Count"
FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
JOIN STACKOVERFLOW.STACKOVERFLOW."USERS" u
  ON q."owner_user_id" = u."id"
LEFT JOIN Badges_CTE bc
  ON u."id" = bc."user_id"
WHERE q."accepted_answer_id" IS NOT NULL
   OR q."id" IN (SELECT "question_id" FROM HighScoreQuestions_CTE)
ORDER BY LENGTH(q."body") DESC NULLS LAST
LIMIT 10;