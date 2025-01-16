SELECT
    DATEDIFF('year', TO_TIMESTAMP_NTZ(U."creation_date" / 1000000), DATE '2023-10-01') AS "number_of_complete_years",
    ROUND(AVG(U."reputation"), 4) AS "average_reputation",
    ROUND(AVG(COALESCE(B.badge_count, 0)), 4) AS "average_number_of_badges"
FROM
    STACKOVERFLOW.STACKOVERFLOW.USERS U
LEFT JOIN (
    SELECT "user_id", COUNT(*) AS badge_count
    FROM STACKOVERFLOW.STACKOVERFLOW.BADGES
    GROUP BY "user_id"
) B ON U."id" = B."user_id"
WHERE
    U."creation_date" <= (DATE_PART(EPOCH_SECOND, DATE '2021-10-01') * 1000000)
GROUP BY
    "number_of_complete_years"
ORDER BY
    "number_of_complete_years";