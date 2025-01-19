SELECT
    "years_of_membership",
    ROUND(AVG("reputation"), 4) AS "average_reputation",
    ROUND(AVG("badge_count"), 4) AS "average_badge_count"
FROM (
    SELECT
        "USERS"."id" AS "user_id",
        "USERS"."reputation",
        FLOOR(
            DATEDIFF(
                'year',
                TO_TIMESTAMP("USERS"."creation_date" / 1000000),
                TO_TIMESTAMP('2023-10-01', 'YYYY-MM-DD')
            )
        ) AS "years_of_membership",
        COUNT("BADGES"."id") AS "badge_count"
    FROM
        STACKOVERFLOW.STACKOVERFLOW.USERS AS "USERS"
    LEFT JOIN
        STACKOVERFLOW.STACKOVERFLOW.BADGES AS "BADGES"
    ON
        "USERS"."id" = "BADGES"."user_id"
    WHERE
        TO_TIMESTAMP("USERS"."creation_date" / 1000000) <= TO_TIMESTAMP('2021-10-01', 'YYYY-MM-DD')
    GROUP BY
        "USERS"."id",
        "USERS"."reputation",
        "years_of_membership"
) AS "user_stats"
GROUP BY
    "years_of_membership"
ORDER BY
    "years_of_membership";