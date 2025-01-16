SELECT
    FLOOR(DATEDIFF('year', TO_TIMESTAMP_NTZ(u."creation_date" / 1e6), DATE('2021-10-01'))) AS "years_membership",
    ROUND(AVG(u."reputation"), 4) AS "average_reputation",
    ROUND(AVG(COALESCE(bc."badge_count", 0)), 4) AS "average_number_of_badges"
FROM
    "STACKOVERFLOW"."STACKOVERFLOW"."USERS" AS u
LEFT JOIN
    (
        SELECT
            b."user_id",
            COUNT(*) AS "badge_count"
        FROM
            "STACKOVERFLOW"."STACKOVERFLOW"."BADGES" AS b
        GROUP BY
            b."user_id"
    ) AS bc
ON
    u."id" = bc."user_id"
WHERE
    TO_TIMESTAMP_NTZ(u."creation_date" / 1e6) <= DATE('2021-10-01')
GROUP BY
    "years_membership"
ORDER BY
    "years_membership";