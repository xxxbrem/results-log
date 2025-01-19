SELECT owner_user_id AS User_ID, tags AS Tag
FROM `bigquery-public-data.stackoverflow.posts_questions`
WHERE owner_user_id BETWEEN 16712208 AND 18712208
  AND creation_date BETWEEN '2019-07-01' AND '2019-12-31'

UNION ALL

SELECT a.owner_user_id AS User_ID, q.tags AS Tag
FROM `bigquery-public-data.stackoverflow.posts_answers` AS a
JOIN `bigquery-public-data.stackoverflow.posts_questions` AS q
  ON a.parent_id = q.id
WHERE a.owner_user_id BETWEEN 16712208 AND 18712208
  AND a.creation_date BETWEEN '2019-07-01' AND '2019-12-31'

UNION ALL

SELECT c.user_id AS User_ID, q.tags AS Tag
FROM `bigquery-public-data.stackoverflow.comments` AS c
JOIN `bigquery-public-data.stackoverflow.posts_questions` AS q
  ON c.post_id = q.id
WHERE c.user_id BETWEEN 16712208 AND 18712208
  AND c.creation_date BETWEEN '2019-07-01' AND '2019-12-31'

UNION ALL

SELECT c.user_id AS User_ID, q.tags AS Tag
FROM `bigquery-public-data.stackoverflow.comments` AS c
JOIN `bigquery-public-data.stackoverflow.posts_answers` AS a
  ON c.post_id = a.id
JOIN `bigquery-public-data.stackoverflow.posts_questions` AS q
  ON a.parent_id = q.id
WHERE c.user_id BETWEEN 16712208 AND 18712208
  AND c.creation_date BETWEEN '2019-07-01' AND '2019-12-31'