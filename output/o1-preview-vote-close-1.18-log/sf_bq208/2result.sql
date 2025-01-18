WITH nearby_stations AS (
    SELECT "usaf", "wban", "name"
    FROM NEW_YORK_NOAA.NOAA_GSOD.STATIONS
    WHERE
        "lat" IS NOT NULL
        AND "lon" IS NOT NULL
        AND ST_DWITHIN(
            ST_MAKEPOINT("lon", "lat"),
            ST_MAKEPOINT(-73.7640, 41.1970),
            32186.9000
        )
),
gsod_data AS (
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2011
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2012
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2013
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2014
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2015
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2016
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2017
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2018
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2019
    UNION ALL
    SELECT "stn", "wban", "temp"
    FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2020
)
SELECT
    s."usaf" || '-' || s."wban" AS "Station_ID",
    s."name" AS "Station_Name",
    COUNT(g."temp") AS "Number_of_Temperature_Observations"
FROM gsod_data g
JOIN nearby_stations s
    ON s."usaf" = g."stn" AND s."wban" = g."wban"
WHERE g."temp" IS NOT NULL
GROUP BY s."usaf", s."wban", s."name"
ORDER BY "Number_of_Temperature_Observations" DESC NULLS LAST;