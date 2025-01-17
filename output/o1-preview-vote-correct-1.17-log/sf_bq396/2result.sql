WITH accidents_by_state AS (
    SELECT
        "state_name",
        SUM(CASE WHEN "atmospheric_conditions_1_name" = 'Rain' THEN 1 ELSE 0 END) AS rain_accidents,
        SUM(CASE WHEN "atmospheric_conditions_1_name" = 'Clear' THEN 1 ELSE 0 END) AS clear_accidents
    FROM NHTSA_TRAFFIC_FATALITIES.NHTSA_TRAFFIC_FATALITIES.ACCIDENT_2016
    WHERE
        "day_of_week" IN (1, 7)
        AND "atmospheric_conditions_1_name" IN ('Rain', 'Clear')
    GROUP BY
        "state_name"
)
SELECT
    "state_name",
    ABS(rain_accidents - clear_accidents) AS difference_in_accidents
FROM accidents_by_state
ORDER BY difference_in_accidents DESC NULLS LAST
LIMIT 3;