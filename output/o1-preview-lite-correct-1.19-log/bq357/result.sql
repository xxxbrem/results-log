WITH all_data AS (
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2005`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2006`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2007`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2008`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2009`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2010`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2011`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2012`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2013`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2014`
  UNION ALL
  SELECT
    year,
    month,
    day,
    wind_speed,
    latitude,
    longitude
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2015`
)
SELECT
  CONCAT('POINT(', CAST(longitude AS STRING), ' ', CAST(latitude AS STRING), ')') AS geom,
  DATE(year, month, day) AS date,
  ROUND(AVG(wind_speed / 10.0), 4) AS avg_daily_wind_speed
FROM all_data
WHERE
  wind_speed IS NOT NULL
  AND wind_speed > 0
  AND year BETWEEN 2005 AND 2015
  AND year IS NOT NULL AND month IS NOT NULL AND day IS NOT NULL
GROUP BY geom, date
ORDER BY avg_daily_wind_speed DESC
LIMIT 5