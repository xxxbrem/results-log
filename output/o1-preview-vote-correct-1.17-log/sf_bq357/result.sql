SELECT
    TO_DATE(CONCAT(t."year", '-', t."month", '-', t."day"), 'YYYY-MM-DD') AS "Date",
    ROUND(t."latitude", 4) AS "Latitude",
    ROUND(t."longitude", 4) AS "Longitude",
    ROUND(AVG(t."wind_speed"), 4) AS "Average_Wind_Speed"
FROM
    (
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
    ) AS t
WHERE
    t."wind_speed" IS NOT NULL
    AND t."year" BETWEEN 2005 AND 2015
    AND t."month" IS NOT NULL
    AND t."day" IS NOT NULL
    AND t."latitude" IS NOT NULL
    AND t."longitude" IS NOT NULL
GROUP BY
    "Date", "Latitude", "Longitude"
ORDER BY
    "Average_Wind_Speed" DESC NULLS LAST
LIMIT 5;