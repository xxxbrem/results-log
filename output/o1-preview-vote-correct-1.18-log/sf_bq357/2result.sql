SELECT
    DATE_FROM_PARTS("year", "month", "day") AS "Date",
    ROUND("latitude", 4) AS "Latitude",
    ROUND("longitude", 4) AS "Longitude",
    ROUND(AVG("wind_speed"), 4) AS "Average_Wind_Speed"
FROM (
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2005"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2006"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2007"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2008"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2009"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2010"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2011"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2012"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2013"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2014"
    UNION ALL
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS."ICOADS_CORE_2015"
) AS combined_data
WHERE "wind_speed" IS NOT NULL
  AND "year" BETWEEN 2005 AND 2015
GROUP BY "Date", "Latitude", "Longitude"
ORDER BY "Average_Wind_Speed" DESC NULLS LAST
LIMIT 5;