WITH temp_data AS (
    SELECT "year","month","air_temperature","wetbulb_temperature","dewpoint_temperature","sea_surface_temp"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2010
    WHERE "year" BETWEEN 2010 AND 2014
    UNION ALL
    SELECT "year","month","air_temperature","wetbulb_temperature","dewpoint_temperature","sea_surface_temp"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2011
    WHERE "year" BETWEEN 2010 AND 2014
    UNION ALL
    SELECT "year","month","air_temperature","wetbulb_temperature","dewpoint_temperature","sea_surface_temp"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2012
    WHERE "year" BETWEEN 2010 AND 2014
    UNION ALL
    SELECT "year","month","air_temperature","wetbulb_temperature","dewpoint_temperature","sea_surface_temp"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2013
    WHERE "year" BETWEEN 2010 AND 2014
    UNION ALL
    SELECT "year","month","air_temperature","wetbulb_temperature","dewpoint_temperature","sea_surface_temp"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2014
    WHERE "year" BETWEEN 2010 AND 2014
)
SELECT 
  "year", 
  "month", 
  ROUND(
    ABS(avg_air_temp - avg_wetbulb_temp) + 
    ABS(avg_air_temp - avg_dewpoint_temp) + 
    ABS(avg_air_temp - avg_sea_surface_temp) + 
    ABS(avg_wetbulb_temp - avg_dewpoint_temp) + 
    ABS(avg_wetbulb_temp - avg_sea_surface_temp) + 
    ABS(avg_dewpoint_temp - avg_sea_surface_temp),
    4
  ) AS sum_of_differences
FROM (
  SELECT 
    "year",
    "month",
    AVG("air_temperature") AS avg_air_temp,
    AVG("wetbulb_temperature") AS avg_wetbulb_temp,
    AVG("dewpoint_temperature") AS avg_dewpoint_temp,
    AVG("sea_surface_temp") AS avg_sea_surface_temp
  FROM temp_data
  WHERE 
    "air_temperature" IS NOT NULL AND
    "wetbulb_temperature" IS NOT NULL AND
    "dewpoint_temperature" IS NOT NULL AND 
    "sea_surface_temp" IS NOT NULL
  GROUP BY "year", "month"
) avg_temps
ORDER BY 
  sum_of_differences ASC NULLS LAST
LIMIT 3;