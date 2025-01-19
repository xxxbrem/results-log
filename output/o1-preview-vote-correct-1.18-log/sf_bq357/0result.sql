WITH combined AS (
    SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
    FROM (
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2005"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2006"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2007"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2008"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2009"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2010"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2011"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2012"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2013"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2014"
        UNION ALL
        SELECT "year", "month", "day", "latitude", "longitude", "wind_speed"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2015"
    )
    WHERE "year" BETWEEN 2005 AND 2015 AND "wind_speed" IS NOT NULL
)
SELECT
    TO_DATE(CONCAT("year", '-', "month", '-', "day")) AS "date",
    ROUND("latitude", 4) AS "latitude",
    ROUND("longitude", 4) AS "longitude",
    ROUND(AVG("wind_speed"), 4) AS "average_wind_speed"
FROM combined
GROUP BY "year", "month", "day", "latitude", "longitude"
ORDER BY "average_wind_speed" DESC NULLS LAST
LIMIT 5;