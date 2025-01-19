WITH weekend_weather AS (
    SELECT
        "state_name",
        CASE 
            WHEN ("atmospheric_conditions_1_name" IN ('Rain', 'Freezing Rain or Drizzle') OR
                  "atmospheric_conditions_2_name" IN ('Rain', 'Freezing Rain or Drizzle')) THEN 'Rain'
            WHEN "atmospheric_conditions_1_name" = 'Clear' AND 
                 ("atmospheric_conditions_2_name" IS NULL OR "atmospheric_conditions_2_name" = 'No Additional Atmospheric Conditions') THEN 'Clear'
            ELSE NULL
        END AS weather_condition
    FROM
        NHTSA_TRAFFIC_FATALITIES.NHTSA_TRAFFIC_FATALITIES.ACCIDENT_2016
    WHERE
        "day_of_week" IN (1, 7)
)
SELECT
    "state_name",
    ABS(SUM(CASE WHEN weather_condition = 'Rain' THEN 1 ELSE 0 END) -
        SUM(CASE WHEN weather_condition = 'Clear' THEN 1 ELSE 0 END))::decimal(10,4) AS "difference"
FROM
    weekend_weather
WHERE
    weather_condition IN ('Rain', 'Clear')
GROUP BY
    "state_name"
ORDER BY
    "difference" DESC NULLS LAST
LIMIT 3;