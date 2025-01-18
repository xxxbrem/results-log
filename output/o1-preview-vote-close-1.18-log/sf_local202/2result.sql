WITH top_states AS (
  SELECT "state", COUNT(*) AS "total_aliens"
  FROM CITY_LEGISLATION.CITY_LEGISLATION.ALIEN_DATA
  GROUP BY "state"
  ORDER BY "total_aliens" DESC NULLS LAST
  LIMIT 10
),
state_stats AS (
  SELECT a."state",
    SUM(CASE WHEN a."aggressive" = 0 THEN 1 ELSE 0 END) AS "friendly_aliens",
    SUM(CASE WHEN a."aggressive" = 1 THEN 1 ELSE 0 END) AS "hostile_aliens",
    AVG(a."age") AS "average_age"
  FROM CITY_LEGISLATION.CITY_LEGISLATION.ALIEN_DATA a
  JOIN top_states s ON a."state" = s."state"
  GROUP BY a."state"
)
SELECT COUNT(*) AS "Number_of_states"
FROM state_stats
WHERE "average_age" > 200 AND "friendly_aliens" > "hostile_aliens";