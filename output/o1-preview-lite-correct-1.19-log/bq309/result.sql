WITH question_stats AS (
  SELECT
    q.id AS question_id,
    LENGTH(q.body) AS body_length,
    q.owner_user_id,
    q.score AS net_votes,
    q.view_count,
    q.accepted_answer_id,
    MAX(a.score) AS max_answer_score
  FROM
    `bigquery-public-data.stackoverflow.posts_questions` q
  LEFT JOIN
    `bigquery-public-data.stackoverflow.posts_answers` a
  ON
    q.id = a.parent_id
  GROUP BY
    q.id, q.body, q.owner_user_id, q.score, q.view_count, q.accepted_answer_id
),
question_candidates AS (
  SELECT
    question_id,
    body_length,
    owner_user_id,
    net_votes
  FROM
    question_stats
  WHERE
    accepted_answer_id IS NOT NULL
    OR (view_count > 0 AND max_answer_score / view_count > 0.01)
),
badge_counts AS (
  SELECT
    user_id,
    COUNT(*) AS badge_count
  FROM
    `bigquery-public-data.stackoverflow.badges`
  GROUP BY
    user_id
),
questions_with_details AS (
  SELECT
    q.question_id,
    q.body_length,
    IFNULL(u.reputation, 0) AS user_reputation,
    q.net_votes,
    IFNULL(b.badge_count, 0) AS badge_count
  FROM
    question_candidates q
  LEFT JOIN
    `bigquery-public-data.stackoverflow.users` u
  ON
    q.owner_user_id = u.id
  LEFT JOIN
    badge_counts b
  ON
    q.owner_user_id = b.user_id
)
SELECT
  question_id,
  body_length,
  user_reputation,
  net_votes,
  badge_count
FROM
  questions_with_details
ORDER BY
  body_length DESC,
  question_id
LIMIT
  10;