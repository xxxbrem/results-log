WITH trip_data AS (
  SELECT
    ROUND(trip_seconds / 60) AS trip_duration_minutes,
    fare
  FROM
    `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE
    trip_seconds <= 3600
    AND trip_seconds > 0
    AND fare IS NOT NULL
    AND fare > 0
),

percentiles AS (
  SELECT
    APPROX_QUANTILES(trip_duration_minutes, 6) AS percentiles
  FROM
    trip_data
),

trip_with_quantile AS (
  SELECT
    td.*,
    CASE
      WHEN td.trip_duration_minutes < p.percentiles[OFFSET(1)] THEN 1
      WHEN td.trip_duration_minutes < p.percentiles[OFFSET(2)] THEN 2
      WHEN td.trip_duration_minutes < p.percentiles[OFFSET(3)] THEN 3
      WHEN td.trip_duration_minutes < p.percentiles[OFFSET(4)] THEN 4
      WHEN td.trip_duration_minutes < p.percentiles[OFFSET(5)] THEN 5
      ELSE 6
    END AS quantile
  FROM
    trip_data td
    CROSS JOIN percentiles p
)

SELECT
  quantile AS Quantile,
  MIN(trip_duration_minutes) AS Min_Trip_Duration_Minutes,
  MAX(trip_duration_minutes) AS Max_Trip_Duration_Minutes,
  COUNT(*) AS Total_Trips,
  ROUND(AVG(fare), 4) AS Average_Fare
FROM
  trip_with_quantile
GROUP BY
  quantile
ORDER BY
  quantile;