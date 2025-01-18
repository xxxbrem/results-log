WITH user_net_votes AS (
    SELECT posts."owner_user_id", 
           SUM(NVL(votes_per_post."upvotes", 0)) - SUM(NVL(votes_per_post."downvotes", 0)) AS "User_Net_Votes"
    FROM (
        SELECT "id", "owner_user_id"
        FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS"
        UNION ALL
        SELECT "id", "owner_user_id"
        FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS"
    ) posts
    LEFT JOIN (
        SELECT v."post_id", 
               SUM(CASE WHEN v."vote_type_id" = 2 THEN 1 ELSE 0 END) AS "upvotes", 
               SUM(CASE WHEN v."vote_type_id" = 3 THEN 1 ELSE 0 END) AS "downvotes"
        FROM STACKOVERFLOW.STACKOVERFLOW."VOTES" v
        GROUP BY v."post_id"
    ) votes_per_post ON posts."id" = votes_per_post."post_id"
    GROUP BY posts."owner_user_id"
),
user_badge_counts AS (
    SELECT "user_id", COUNT(*) AS "badge_count"
    FROM STACKOVERFLOW.STACKOVERFLOW."BADGES"
    GROUP BY "user_id"
),
answer_scores AS (
    SELECT pa."parent_id" AS "question_id",
           MAX(pa."score") AS "max_answer_score"
    FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" pa
    GROUP BY pa."parent_id"
)
SELECT CAST(pq."id" AS STRING) AS "Question_ID",
       CAST(pq."title" AS STRING) AS "Question_Title",
       LENGTH(pq."body") AS "Question_Length",
       CAST(pq."owner_user_id" AS STRING) AS "User_ID",
       CAST(u."reputation" AS INTEGER) AS "User_Reputation",
       CAST(user_net_votes."User_Net_Votes" AS INTEGER) AS "User_Net_Votes",
       CAST(user_badge_counts."badge_count" AS INTEGER) AS "User_Badge_Count"
FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" pq
LEFT JOIN STACKOVERFLOW.STACKOVERFLOW."USERS" u ON pq."owner_user_id" = u."id"
LEFT JOIN user_net_votes ON pq."owner_user_id" = user_net_votes."owner_user_id"
LEFT JOIN user_badge_counts ON pq."owner_user_id" = user_badge_counts."user_id"
LEFT JOIN answer_scores ans ON pq."id" = ans."question_id"
WHERE pq."accepted_answer_id" IS NOT NULL
   OR (pq."view_count" > 0 AND ans."max_answer_score" / NULLIF(pq."view_count", 0) > 0.01)
ORDER BY LENGTH(pq."body") DESC NULLS LAST
LIMIT 10;