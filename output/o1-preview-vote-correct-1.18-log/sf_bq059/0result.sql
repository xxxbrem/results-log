WITH berkeley_stations AS (
    SELECT "station_id"
    FROM SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_STATION_INFO
    WHERE "region_id" = (
        SELECT "region_id"
        FROM SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_REGIONS
        WHERE "name" = 'Berkeley'
    )
),
berkeley_trips AS (
    SELECT *
    FROM SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_TRIPS t
    WHERE
        (
            t."start_station_id" IN (SELECT "station_id" FROM berkeley_stations)
            OR t."end_station_id" IN (SELECT "station_id" FROM berkeley_stations)
        )
        AND t."start_station_latitude" IS NOT NULL
        AND t."start_station_longitude" IS NOT NULL
        AND t."end_station_latitude" IS NOT NULL
        AND t."end_station_longitude" IS NOT NULL
        AND t."duration_sec" > 0
),
trip_distances AS (
    SELECT
        t.*,
        ST_DISTANCE(
            ST_MAKEPOINT(t."start_station_longitude", t."start_station_latitude"),
            ST_MAKEPOINT(t."end_station_longitude", t."end_station_latitude")
        ) AS "distance_meters"
    FROM berkeley_trips t
)
SELECT ROUND(MAX("distance_meters" / "duration_sec"), 1) AS "highest_average_speed_m_s"
FROM trip_distances
WHERE "distance_meters" > 1000;