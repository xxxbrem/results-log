SELECT
  TO_DATE(CONCAT(all_data."year", '-', LPAD(all_data."month", 2, '0'), '-', LPAD(all_data."day", 2, '0')), 'YYYY-MM-DD') AS "Date",
  all_data."latitude" AS "Latitude",
  all_data."longitude" AS "Longitude",
  ROUND(AVG(all_data."wind_speed"), 4) AS "Average_Wind_Speed"
FROM (
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2005
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2006
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2007
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2008
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2009
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2010
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2011
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2012
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2013
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2014
  UNION ALL
  SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
  FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2015
) AS all_data
WHERE all_data."year" BETWEEN 2005 AND 2015
  AND all_data."wind_speed" IS NOT NULL
GROUP BY all_data."year", all_data."month", all_data."day", all_data."latitude", all_data."longitude"
ORDER BY "Average_Wind_Speed" DESC NULLS LAST, all_data."latitude" ASC, all_data."longitude" ASC
LIMIT 5;