SELECT
    DAYNAME(TO_TIMESTAMP_NTZ(q."creation_date" / 1e6)) AS "Day_of_Week",
    COUNT(*) AS "Number_of_Questions",
    COUNT(
        CASE
            WHEN a."creation_date" IS NOT NULL
                AND (a."creation_date" - q."creation_date") <= 3600000000
            THEN 1
        END
    ) AS "Number_Answered_Within_1_Hour",
    ROUND(
        COUNT(
            CASE
                WHEN a."creation_date" IS NOT NULL
                    AND (a."creation_date" - q."creation_date") <= 3600000000
                THEN 1
            END
        ) * 100.0 / COUNT(*), 4
    ) AS "Percentage_Answered_Within_1_Hour"
FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" q
LEFT JOIN (
    SELECT "parent_id", MIN("creation_date") AS "creation_date"
    FROM STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS"
    GROUP BY "parent_id"
) a
ON q."id" = a."parent_id"
WHERE q."creation_date" >= 1609459200000000
  AND q."creation_date" < 1640995200000000
GROUP BY
    DATE_PART('DAYOFWEEKISO', TO_TIMESTAMP_NTZ(q."creation_date" / 1e6)),
    DAYNAME(TO_TIMESTAMP_NTZ(q."creation_date" / 1e6))
ORDER BY
    DATE_PART('DAYOFWEEKISO', TO_TIMESTAMP_NTZ(q."creation_date" / 1e6));