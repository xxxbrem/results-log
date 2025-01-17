SELECT
    "state_name",
    ABS(clear_accidents - rainy_accidents) AS difference_in_accidents
FROM (
    SELECT
        "state_name",
        SUM(CASE WHEN "atmospheric_conditions_1_name" = 'Clear' OR "atmospheric_conditions_2_name" = 'Clear' THEN 1 ELSE 0 END) AS clear_accidents,
        SUM(CASE WHEN "atmospheric_conditions_1_name" IN ('Rain', 'Freezing Rain or Drizzle') OR "atmospheric_conditions_2_name" IN ('Rain', 'Freezing Rain or Drizzle') THEN 1 ELSE 0 END) AS rainy_accidents
    FROM NHTSA_TRAFFIC_FATALITIES.NHTSA_TRAFFIC_FATALITIES.ACCIDENT_2016
    WHERE "day_of_week" IN (1,7)  -- Weekends: Sunday(1) and Saturday(7)
    GROUP BY "state_name"
) AS sub
ORDER BY difference_in_accidents DESC NULLS LAST
LIMIT 3;