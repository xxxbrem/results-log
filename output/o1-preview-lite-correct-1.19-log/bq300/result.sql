SELECT answer_count, id, title
FROM `bigquery-public-data.stackoverflow.posts_questions`
WHERE 'python-2.x' IN UNNEST(SPLIT(tags, '|'))
  AND 'python-3.x' NOT IN UNNEST(SPLIT(tags, '|'))
ORDER BY answer_count DESC
LIMIT 1