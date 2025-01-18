WITH nearby_stations AS (
    SELECT 
        LPAD(TRIM("usaf"), 6, '0') AS station_id, 
        "name"
    FROM 
        "NEW_YORK_NOAA"."NOAA_GSOD"."STATIONS"
    WHERE 
        "lat" IS NOT NULL 
        AND "lon" IS NOT NULL 
        AND "usaf" IS NOT NULL 
        AND TRIM("usaf") != ''
        AND ST_DWITHIN(
            ST_POINT("lon", "lat"),
            ST_POINT(-73.7640, 41.1970),
            32186.8
        )
)

SELECT
    ns.station_id,
    ns."name" AS station_name,
    COUNT(*) AS number_of_temperature_observations
FROM
    nearby_stations ns
JOIN (
    SELECT 
        LPAD(TRIM("stn"), 6, '0') AS station_id
    FROM (
        SELECT "stn", "temp" 
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2011"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2012"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2013"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2014"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2015"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2016"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2017"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2018"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2019"
        UNION ALL
        SELECT "stn", "temp"
        FROM "NEW_YORK_NOAA"."NOAA_GSOD"."GSOD2020"
    ) all_obs
    WHERE 
        "temp" IS NOT NULL 
        AND "stn" IS NOT NULL 
        AND TRIM("stn") != ''
) g
ON ns.station_id = g.station_id
GROUP BY
    ns.station_id, ns."name";