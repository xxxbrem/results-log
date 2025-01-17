SELECT "state_name",
  ABS(
    SUM(CASE WHEN LOWER("atmospheric_conditions_1_name") LIKE '%rain%' THEN 1 ELSE 0 END) -
    SUM(CASE WHEN LOWER("atmospheric_conditions_1_name") LIKE '%clear%' THEN 1 ELSE 0 END)
  ) AS "difference_in_accidents"
FROM NHTSA_TRAFFIC_FATALITIES.NHTSA_TRAFFIC_FATALITIES.ACCIDENT_2016
WHERE "day_of_week" IN (1, 7)
GROUP BY "state_name"
ORDER BY "difference_in_accidents" DESC NULLS LAST
LIMIT 3;