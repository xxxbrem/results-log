WITH trips_filtered AS (
  SELECT
    trip_seconds / 60 AS duration_minutes_unrounded,
    ROUND(trip_seconds / 60) AS duration_minutes,
    fare
  FROM
    `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE
    trip_seconds IS NOT NULL
      AND trip_seconds > 0
      AND fare IS NOT NULL
      AND fare >= 1.00
      AND ROUND(trip_seconds / 60) BETWEEN 1 AND 50
),
trips_with_quantiles AS (
  SELECT
    duration_minutes,
    fare,
    NTILE(10) OVER (ORDER BY duration_minutes_unrounded) AS quantile
  FROM
    trips_filtered
)
SELECT
  CONCAT(
    CAST(MIN(duration_minutes) AS STRING),
    ' - ',
    CAST(MAX(duration_minutes) AS STRING)
  ) AS Duration_Range_Minutes,
  COUNT(*) AS Total_Trips,
  ROUND(AVG(fare), 4) AS Average_Fare
FROM
  trips_with_quantiles
GROUP BY
  quantile
ORDER BY
  quantile;