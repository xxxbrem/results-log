SELECT COUNT(*) AS "Number_of_states"
FROM (
    SELECT "state"
    FROM (
        SELECT "state",
            ROUND(AVG("age"), 4) AS "average_age",
            SUM(CASE WHEN "aggressive" = 0 THEN 1 ELSE 0 END) AS "friendly_aliens",
            SUM(CASE WHEN "aggressive" = 1 THEN 1 ELSE 0 END) AS "hostile_aliens"
        FROM CITY_LEGISLATION.CITY_LEGISLATION.ALIEN_DATA
        WHERE "state" IN (
            SELECT "state"
            FROM CITY_LEGISLATION.CITY_LEGISLATION.ALIEN_DATA
            GROUP BY "state"
            ORDER BY COUNT("id") DESC NULLS LAST
            LIMIT 10
        )
        GROUP BY "state"
    ) AS state_stats
    WHERE "average_age" > 200 AND "friendly_aliens" > "hostile_aliens"
) AS qualified_states;