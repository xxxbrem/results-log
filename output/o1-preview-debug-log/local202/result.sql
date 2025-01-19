WITH TopStates AS (
    SELECT "state"
    FROM "alien_data"
    GROUP BY "state"
    ORDER BY COUNT("id") DESC
    LIMIT 10
),
StateStats AS (
    SELECT 
        "state",
        COUNT("id") AS "total_aliens",
        SUM(CASE WHEN "aggressive" = 0 THEN 1 ELSE 0 END) AS "friendly_count",
        SUM(CASE WHEN "aggressive" = 1 THEN 1 ELSE 0 END) AS "hostile_count",
        ROUND(AVG("age"), 4) AS "average_age"
    FROM "alien_data"
    WHERE "state" IN (SELECT "state" FROM TopStates)
    GROUP BY "state"
)
SELECT COUNT(*) AS Number_of_states
FROM StateStats
WHERE "friendly_count" > "hostile_count"
AND "average_age" > 200;