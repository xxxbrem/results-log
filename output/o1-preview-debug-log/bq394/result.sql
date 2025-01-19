WITH all_data AS (
  SELECT 
    year, 
    month, 
    air_temperature, 
    wetbulb_temperature, 
    dewpoint_temperature, 
    sea_surface_temp
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2010`
  WHERE air_temperature IS NOT NULL 
    AND wetbulb_temperature IS NOT NULL 
    AND dewpoint_temperature IS NOT NULL 
    AND sea_surface_temp IS NOT NULL
  UNION ALL
  SELECT 
    year, 
    month, 
    air_temperature, 
    wetbulb_temperature, 
    dewpoint_temperature, 
    sea_surface_temp
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2011`
  WHERE air_temperature IS NOT NULL 
    AND wetbulb_temperature IS NOT NULL 
    AND dewpoint_temperature IS NOT NULL 
    AND sea_surface_temp IS NOT NULL
  UNION ALL
  SELECT 
    year, 
    month, 
    air_temperature, 
    wetbulb_temperature, 
    dewpoint_temperature, 
    sea_surface_temp
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2012`
  WHERE air_temperature IS NOT NULL 
    AND wetbulb_temperature IS NOT NULL 
    AND dewpoint_temperature IS NOT NULL 
    AND sea_surface_temp IS NOT NULL
  UNION ALL
  SELECT 
    year, 
    month, 
    air_temperature, 
    wetbulb_temperature, 
    dewpoint_temperature, 
    sea_surface_temp
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2013`
  WHERE air_temperature IS NOT NULL 
    AND wetbulb_temperature IS NOT NULL 
    AND dewpoint_temperature IS NOT NULL 
    AND sea_surface_temp IS NOT NULL
  UNION ALL
  SELECT 
    year, 
    month, 
    air_temperature, 
    wetbulb_temperature, 
    dewpoint_temperature, 
    sea_surface_temp
  FROM `bigquery-public-data.noaa_icoads.icoads_core_2014`
  WHERE air_temperature IS NOT NULL 
    AND wetbulb_temperature IS NOT NULL 
    AND dewpoint_temperature IS NOT NULL 
    AND sea_surface_temp IS NOT NULL
)
SELECT
  year,
  month,
  ROUND(
    ABS(avg_air_temp - avg_wetbulb_temp) +
    ABS(avg_air_temp - avg_dewpoint_temp) +
    ABS(avg_air_temp - avg_sea_surface_temp) +
    ABS(avg_wetbulb_temp - avg_dewpoint_temp) +
    ABS(avg_wetbulb_temp - avg_sea_surface_temp) +
    ABS(avg_dewpoint_temp - avg_sea_surface_temp),
    4
  ) AS SumAbsDiff
FROM (
  SELECT
    year,
    month,
    AVG(air_temperature) AS avg_air_temp,
    AVG(wetbulb_temperature) AS avg_wetbulb_temp,
    AVG(dewpoint_temperature) AS avg_dewpoint_temp,
    AVG(sea_surface_temp) AS avg_sea_surface_temp
  FROM all_data
  GROUP BY year, month
)
ORDER BY SumAbsDiff ASC
LIMIT 3;