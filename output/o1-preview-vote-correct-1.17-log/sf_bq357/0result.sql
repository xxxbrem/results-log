SELECT
    "date",
    "latitude",
    "longitude",
    ROUND(AVG("wind_speed"), 4) AS "daily_average_wind_speed"
FROM
(
    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2005
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2006
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2007
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2008
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2009
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2010
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2011
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2012
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2013
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2014
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015

    UNION ALL

    SELECT
        DATE_FROM_PARTS("year", "month", "day") AS "date",
        "latitude",
        "longitude",
        "wind_speed"
    FROM NOAA_DATA.NOAA_ICOADS.ICOADS_CORE_2015
    WHERE "wind_speed" IS NOT NULL AND "year" BETWEEN 2005 AND 2015
) AS combined_data
GROUP BY
    "date",
    "latitude",
    "longitude"
ORDER BY
    "daily_average_wind_speed" DESC NULLS LAST
LIMIT 5;