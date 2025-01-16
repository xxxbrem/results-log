SELECT
    YEARS_AS_MEMBER,
    ROUND(AVG("reputation"), 4) AS Average_reputation,
    ROUND(AVG(Badge_Count), 4) AS Average_number_of_badges
FROM
(
    SELECT
        U."id",
        U."reputation",
        DATEDIFF('year', TO_TIMESTAMP_NTZ(U."creation_date" / 1e6), DATE '2021-10-01') AS YEARS_AS_MEMBER,
        COUNT(B."id") AS Badge_Count
    FROM STACKOVERFLOW.STACKOVERFLOW.USERS U
    LEFT JOIN STACKOVERFLOW.STACKOVERFLOW.BADGES B ON U."id" = B."user_id"
    WHERE U."creation_date" <= 1633046400000000  -- October 1, 2021 in microseconds
    GROUP BY U."id", U."reputation", U."creation_date"
) AS USER_BADGES
GROUP BY YEARS_AS_MEMBER
ORDER BY YEARS_AS_MEMBER;