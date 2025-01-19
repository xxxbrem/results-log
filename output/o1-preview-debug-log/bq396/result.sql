SELECT
  state_name,
  ABS(accidents_clear - accidents_rain) AS accident_difference
FROM
  (
    SELECT
      state_name,
      SUM(CASE WHEN atmospheric_conditions_1 = 1 THEN 1 ELSE 0 END) AS accidents_clear,
      SUM(CASE WHEN atmospheric_conditions_1 = 2 THEN 1 ELSE 0 END) AS accidents_rain
    FROM `bigquery-public-data.nhtsa_traffic_fatalities.accident_2016`
    WHERE day_of_week IN (1,7)
    GROUP BY state_name
  )
ORDER BY accident_difference DESC
LIMIT 3;