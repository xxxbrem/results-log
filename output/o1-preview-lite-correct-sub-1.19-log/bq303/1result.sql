SELECT user_id, tags
FROM (
  SELECT owner_user_id AS user_id,
         tags,
         creation_date
  FROM `bigquery-public-data.stackoverflow.posts_questions`
  UNION ALL
  SELECT pa.owner_user_id AS user_id,
         pq.tags,
         pa.creation_date
  FROM `bigquery-public-data.stackoverflow.posts_answers` AS pa
  JOIN `bigquery-public-data.stackoverflow.posts_questions` AS pq
    ON pa.parent_id = pq.id
  UNION ALL
  SELECT c.user_id AS user_id,
         COALESCE(pq1.tags, pq2.tags) AS tags,
         c.creation_date
  FROM `bigquery-public-data.stackoverflow.comments` AS c
  LEFT JOIN `bigquery-public-data.stackoverflow.posts_questions` AS pq1
    ON c.post_id = pq1.id
  LEFT JOIN `bigquery-public-data.stackoverflow.posts_answers` AS pa
    ON c.post_id = pa.id
  LEFT JOIN `bigquery-public-data.stackoverflow.posts_questions` AS pq2
    ON pa.parent_id = pq2.id
)
WHERE user_id BETWEEN 16712208 AND 18712208
  AND creation_date BETWEEN '2019-07-01' AND '2019-12-31'