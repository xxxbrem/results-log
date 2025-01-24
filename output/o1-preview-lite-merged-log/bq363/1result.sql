SELECT
  CONCAT(
    MIN(duration_minutes), ' - ', MAX(duration_minutes)
  ) AS Duration_Range_Minutes,
  COUNT(*) AS Total_Trips,
  ROUND(AVG(fare), 4) AS Average_Fare
FROM (
  SELECT
    ROUND(trip_seconds / 60) AS duration_minutes,
    fare,
    NTILE(10) OVER (ORDER BY ROUND(trip_seconds / 60)) AS duration_quantile
  FROM
    `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE
    trip_seconds > 0
    AND fare IS NOT NULL
    AND fare > 0
    AND ROUND(trip_seconds / 60) BETWEEN 1 AND 50
)
GROUP BY
  duration_quantile
ORDER BY
  duration_quantile;