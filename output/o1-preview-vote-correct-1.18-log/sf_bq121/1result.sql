SELECT
    DATEDIFF(
        'year',
        TO_TIMESTAMP_NTZ(U."creation_date" / 1000000),
        TO_TIMESTAMP_NTZ(1633046400)
    ) AS "years_member",
    ROUND(AVG(U."reputation"), 4) AS "average_reputation",
    ROUND(AVG(COALESCE(BC."badge_count", 0)), 4) AS "average_badges"
FROM
    STACKOVERFLOW.STACKOVERFLOW.USERS U
    LEFT JOIN (
        SELECT
            B."user_id",
            COUNT(*) AS "badge_count"
        FROM
            STACKOVERFLOW.STACKOVERFLOW.BADGES B
        GROUP BY B."user_id"
    ) BC ON U."id" = BC."user_id"
WHERE
    U."creation_date" <= 1633046400000000
GROUP BY "years_member"
ORDER BY "years_member"