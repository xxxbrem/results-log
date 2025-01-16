SELECT
    FLOOR((1696118400000000 - u."creation_date") / 31557600000000) AS "membership_years",
    ROUND(AVG(u."reputation"), 4) AS "average_reputation",
    ROUND(AVG(COALESCE(b.badge_count, 0)), 4) AS "average_number_of_badges"
FROM STACKOVERFLOW.STACKOVERFLOW.USERS u
LEFT JOIN (
    SELECT "user_id", COUNT(*) AS badge_count
    FROM STACKOVERFLOW.STACKOVERFLOW.BADGES
    GROUP BY "user_id"
) b ON u."id" = b."user_id"
WHERE u."creation_date" <= 1633046400000000
GROUP BY "membership_years"
ORDER BY "membership_years";