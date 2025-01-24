SELECT
  CONCAT(
    CAST(MIN(ROUND(trip_seconds / 60)) AS STRING),
    ' to ',
    CAST(MAX(ROUND(trip_seconds / 60)) AS STRING),
    ' minutes'
  ) AS Duration_Range_Minutes,
  COUNT(*) AS Total_Trips,
  ROUND(AVG(trip_total), 4) AS Average_Fare
FROM (
  SELECT
    trip_seconds,
    trip_total,
    NTILE(10) OVER (ORDER BY ROUND(trip_seconds / 60)) AS quantile
  FROM
    `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE
    trip_seconds IS NOT NULL
    AND trip_seconds > 0
    AND trip_total IS NOT NULL
    AND trip_total > 0
    AND ROUND(trip_seconds / 60) BETWEEN 1 AND 50
)
GROUP BY
  quantile
ORDER BY
  quantile;