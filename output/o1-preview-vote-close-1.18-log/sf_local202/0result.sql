WITH top_states AS (
    SELECT "state", COUNT(*) AS total_aliens
    FROM CITY_LEGISLATION.CITY_LEGISLATION.ALIEN_DATA
    GROUP BY "state"
    ORDER BY total_aliens DESC NULLS LAST
    LIMIT 10
),
state_agg AS (
    SELECT
        ad."state",
        ROUND(AVG(ad."age"), 4) AS avg_age,
        SUM(CASE WHEN ad."aggressive" = 0 THEN 1 ELSE 0 END) AS friendly_count,
        SUM(CASE WHEN ad."aggressive" = 1 THEN 1 ELSE 0 END) AS hostile_count
    FROM CITY_LEGISLATION.CITY_LEGISLATION.ALIEN_DATA ad
    JOIN top_states ts ON ad."state" = ts."state"
    GROUP BY ad."state"
)
SELECT
    COUNT(*) AS Number_of_states
FROM
    state_agg
WHERE
    avg_age > 200
    AND friendly_count > hostile_count;