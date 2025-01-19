WITH top_states AS (
    SELECT "state", COUNT(*) AS total_aliens
    FROM "CITY_LEGISLATION"."CITY_LEGISLATION"."ALIEN_DATA"
    GROUP BY "state"
    ORDER BY total_aliens DESC NULLS LAST
    LIMIT 10
),
state_stats AS (
    SELECT
        a."state",
        SUM(CASE WHEN a."aggressive" = 0 THEN 1 ELSE 0 END) AS friendly_aliens,
        SUM(CASE WHEN a."aggressive" = 1 THEN 1 ELSE 0 END) AS hostile_aliens,
        AVG(a."age") AS avg_age
    FROM "CITY_LEGISLATION"."CITY_LEGISLATION"."ALIEN_DATA" a
    WHERE a."state" IN (SELECT "state" FROM top_states)
    GROUP BY a."state"
),
final_states AS (
    SELECT
        s."state"
    FROM state_stats s
    WHERE s.friendly_aliens > s.hostile_aliens
          AND s.avg_age > 200
)
SELECT COUNT(*) AS "Number_of_states"
FROM final_states;