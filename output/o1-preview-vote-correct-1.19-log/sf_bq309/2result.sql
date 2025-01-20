WITH badge_counts AS (
    SELECT
        "user_id",
        COUNT(*) AS "badge_count"
    FROM
        STACKOVERFLOW.STACKOVERFLOW.BADGES
    GROUP BY
        "user_id"
),
answer_stats AS (
    SELECT
        a."parent_id" AS "question_id",
        MAX(
            CASE
                WHEN q."view_count" > 0 THEN CAST(a."score" AS FLOAT) / q."view_count"
                ELSE NULL
            END
        ) AS "max_score_view_ratio"
    FROM
        STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS a
    JOIN
        STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS q
            ON a."parent_id" = q."id"
    GROUP BY
        a."parent_id"
)
SELECT
    q."id" AS question_id,
    CAST(q."title" AS STRING) AS title,
    LENGTH(q."body") AS length,
    u."reputation" AS user_reputation,
    q."score" AS net_votes,
    COALESCE(b."badge_count", 0) AS badge_count
FROM
    STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS q
LEFT JOIN
    STACKOVERFLOW.STACKOVERFLOW.USERS u
        ON q."owner_user_id" = u."id"
LEFT JOIN
    badge_counts b
        ON u."id" = b."user_id"
LEFT JOIN
    answer_stats ans
        ON q."id" = ans."question_id"
WHERE
    q."accepted_answer_id" IS NOT NULL
    OR (ans."max_score_view_ratio" > 0.01)
ORDER BY
    LENGTH(q."body") DESC NULLS LAST,
    q."id" ASC
LIMIT
    10;