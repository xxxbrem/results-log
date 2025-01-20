WITH badge_counts AS (
  SELECT
    "user_id",
    COUNT(*) AS badge_count
  FROM
    "STACKOVERFLOW"."STACKOVERFLOW"."BADGES"
  GROUP BY
    "user_id"
),
questions_with_good_answers AS (
  SELECT DISTINCT
    a."parent_id" AS question_id
  FROM
    "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" a
  JOIN
    "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" q
      ON a."parent_id" = q."id"
  WHERE
    q."view_count" > 0
    AND (a."score" / NULLIF(q."view_count", 0)) > 0.01
)
SELECT
  q."id" AS question_id,
  REPLACE(CAST(q."title" AS STRING), '"', '') AS title,
  LENGTH(q."body") AS length,
  u."reputation" AS user_reputation,
  q."score" AS net_votes,
  COALESCE(b.badge_count, 0) AS badge_count
FROM
  "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" q
JOIN
  "STACKOVERFLOW"."STACKOVERFLOW"."USERS" u
  ON q."owner_user_id" = u."id"
LEFT JOIN
  badge_counts b
  ON u."id" = b."user_id"
LEFT JOIN
  questions_with_good_answers gwa
  ON q."id" = gwa.question_id
WHERE
  q."accepted_answer_id" IS NOT NULL
  OR gwa.question_id IS NOT NULL
ORDER BY
  LENGTH(q."body") DESC NULLS LAST
LIMIT
  10;