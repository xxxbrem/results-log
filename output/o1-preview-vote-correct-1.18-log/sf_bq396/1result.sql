WITH clear_counts AS (
    SELECT "state_name", COUNT(*) AS "clear_weekend_accidents"
    FROM NHTSA_TRAFFIC_FATALITIES.NHTSA_TRAFFIC_FATALITIES.ACCIDENT_2016
    WHERE "atmospheric_conditions_1_name" ILIKE '%Clear%'
      AND "day_of_week" IN (1, 7)
    GROUP BY "state_name"
),
rain_counts AS (
    SELECT "state_name", COUNT(*) AS "rain_weekend_accidents"
    FROM NHTSA_TRAFFIC_FATALITIES.NHTSA_TRAFFIC_FATALITIES.ACCIDENT_2016
    WHERE "atmospheric_conditions_1_name" ILIKE '%Rain%'
      AND "day_of_week" IN (1, 7)
    GROUP BY "state_name"
)
SELECT
    COALESCE(c."state_name", r."state_name") AS "state_name",
    COALESCE(c."clear_weekend_accidents", 0) - COALESCE(r."rain_weekend_accidents", 0) AS "difference"
FROM clear_counts c
FULL OUTER JOIN rain_counts r
    ON c."state_name" = r."state_name"
ORDER BY "difference" DESC NULLS LAST
LIMIT 3;