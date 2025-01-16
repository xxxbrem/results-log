SELECT u."display_name", COUNT(*) AS total_answers
FROM STACKOVERFLOW.STACKOVERFLOW.USERS u
JOIN STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS pa
  ON u."id" = pa."owner_user_id"
WHERE u."reputation" > 10
GROUP BY u."display_name"
ORDER BY total_answers DESC NULLS LAST
LIMIT 1;