SELECT U."display_name"
FROM STACKOVERFLOW.STACKOVERFLOW.USERS U
JOIN STACKOVERFLOW.STACKOVERFLOW.STACKOVERFLOW_POSTS P
  ON U."id" = P."owner_user_id"
WHERE U."reputation" > 10
  AND P."post_type_id" = 2
GROUP BY U."id", U."display_name"
ORDER BY COUNT(*) DESC NULLS LAST
LIMIT 1;