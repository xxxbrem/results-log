WITH monthly_trips AS (
  SELECT
    company,
    EXTRACT(MONTH FROM trip_start_timestamp) AS month,
    COUNT(*) AS trip_count
  FROM
    `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE
    EXTRACT(YEAR FROM trip_start_timestamp) = 2018
  GROUP BY
    company, month
),
monthly_increases AS (
  SELECT
    company,
    month,
    trip_count,
    trip_count - LAG(trip_count) OVER (PARTITION BY company ORDER BY month) AS increase
  FROM
    monthly_trips
)
SELECT
  company,
  MAX(increase) AS max_increase
FROM
  monthly_increases
WHERE
  increase IS NOT NULL
GROUP BY
  company
ORDER BY
  max_increase DESC
LIMIT 3;