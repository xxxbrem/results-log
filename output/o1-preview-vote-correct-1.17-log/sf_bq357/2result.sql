SELECT
    ST_AsText(ST_MakePoint("longitude", "latitude")) AS "geom",
    TO_DATE(TO_VARCHAR("year") || '-' || LPAD(TO_VARCHAR("month"), 2, '0') || '-' || LPAD(TO_VARCHAR("day"), 2, '0')) AS "date",
    ROUND(AVG("wind_speed"), 4) AS "daily_avg_wind_speed"
FROM
    (
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
    ) AS all_data
WHERE
    "wind_speed" IS NOT NULL
    AND "year" BETWEEN 2005 AND 2015
GROUP BY
    "latitude",
    "longitude",
    "year",
    "month",
    "day"
ORDER BY
    AVG("wind_speed") DESC NULLS LAST
LIMIT 5;