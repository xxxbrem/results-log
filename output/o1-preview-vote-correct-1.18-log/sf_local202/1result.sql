SELECT COUNT(*) AS "Number_of_States"
FROM (
    SELECT
        "state",
        ROUND(AVG("age"), 4) AS "average_age",
        SUM(CASE WHEN "aggressive" = 0 THEN 1 ELSE 0 END) AS "friendly_count",
        SUM(CASE WHEN "aggressive" = 1 THEN 1 ELSE 0 END) AS "hostile_count",
        COUNT("id") AS "total_count"
    FROM
        "CITY_LEGISLATION"."CITY_LEGISLATION"."ALIEN_DATA"
    GROUP BY
        "state"
    ORDER BY
        "total_count" DESC NULLS LAST
    LIMIT 10
) AS "top_states"
WHERE
    "friendly_count" > "hostile_count"
    AND "average_age" > 200;