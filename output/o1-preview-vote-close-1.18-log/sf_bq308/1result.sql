SELECT
    "Day_of_Week",
    COUNT(*) AS "Number_of_Questions",
    SUM("Answered_Within_One_Hour") AS "Number_Answered_Within_One_Hour",
    ROUND((SUM("Answered_Within_One_Hour") * 100.0) / COUNT(*), 4) AS "Percentage_Answered_Within_One_Hour"
FROM (
    SELECT
        Q."id",
        DAYNAME(TO_TIMESTAMP_LTZ(Q."creation_date" / 1e6)) AS "Day_of_Week",
        CASE WHEN MIN(A."id") IS NOT NULL THEN 1 ELSE 0 END AS "Answered_Within_One_Hour"
    FROM
        STACKOVERFLOW.STACKOVERFLOW."POSTS_QUESTIONS" Q
        LEFT JOIN STACKOVERFLOW.STACKOVERFLOW."POSTS_ANSWERS" A
            ON A."parent_id" = Q."id"
            AND (A."creation_date" - Q."creation_date") BETWEEN 0 AND 3600000000
    WHERE
        Q."creation_date" BETWEEN 1609459200000000 AND 1640995199000000
    GROUP BY
        Q."id",
        TO_TIMESTAMP_LTZ(Q."creation_date" / 1e6)
)
GROUP BY
    "Day_of_Week"
ORDER BY
    CASE "Day_of_Week"
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
        ELSE 8 END;