SELECT u."display_name"
FROM STACKOVERFLOW.STACKOVERFLOW.USERS u
JOIN STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS pa
    ON u."id" = pa."owner_user_id"
WHERE u."reputation" > 10
GROUP BY u."id", u."display_name"
ORDER BY COUNT(pa."id") DESC NULLS LAST
LIMIT 1;