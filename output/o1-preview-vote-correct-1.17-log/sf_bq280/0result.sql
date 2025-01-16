SELECT u."display_name", COUNT(a."id") AS "number_of_answers"
FROM STACKOVERFLOW.STACKOVERFLOW.USERS u
JOIN STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS a ON u."id" = a."owner_user_id"
WHERE u."reputation" > 10
GROUP BY u."id", u."display_name"
ORDER BY COUNT(a."id") DESC NULLS LAST
LIMIT 1;