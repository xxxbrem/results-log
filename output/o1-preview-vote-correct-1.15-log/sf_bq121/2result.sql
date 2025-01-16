SELECT
    "years_of_membership",
    ROUND(AVG("reputation"), 4) AS "Average_reputation",
    ROUND(AVG("badge_count"), 4) AS "Average_number_of_badges"
FROM (
    SELECT
        u."id" AS "user_id",
        u."reputation",
        COALESCE(b."badge_count", 0) AS "badge_count",
        DATEDIFF('year', TO_TIMESTAMP_NTZ(u."creation_date" / 1000000), TO_DATE('2023-10-01')) AS "years_of_membership"
    FROM STACKOVERFLOW.STACKOVERFLOW.USERS u
    LEFT JOIN (
        SELECT "user_id", COUNT(*) AS "badge_count"
        FROM STACKOVERFLOW.STACKOVERFLOW.BADGES
        GROUP BY "user_id"
    ) b ON u."id" = b."user_id"
    WHERE TO_TIMESTAMP_NTZ(u."creation_date" / 1000000) <= TO_DATE('2021-10-01')
) t
GROUP BY "years_of_membership"
ORDER BY "years_of_membership";