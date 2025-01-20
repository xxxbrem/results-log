SELECT u.display_name
FROM `bigquery-public-data.stackoverflow.posts_answers` AS pa
JOIN `bigquery-public-data.stackoverflow.users` AS u
    ON pa.owner_user_id = u.id
WHERE u.reputation > 10
GROUP BY u.id, u.display_name
ORDER BY COUNT(pa.id) DESC
LIMIT 1;