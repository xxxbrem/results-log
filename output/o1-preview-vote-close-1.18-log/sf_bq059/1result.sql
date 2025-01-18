WITH berkeley_stations AS (
    SELECT DISTINCT s."station_id"
    FROM "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO" s
    JOIN "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_REGIONS" r
      ON s."region_id" = r."region_id"
    WHERE r."name" = 'Berkeley'
)
SELECT
    ROUND(MAX(average_speed_m_s), 1) AS "highest_average_speed_m_s"
FROM (
    SELECT
        "trip_id",
        "duration_sec",
        ST_DISTANCE(
            TO_GEOGRAPHY(ST_MAKEPOINT("start_station_longitude", "start_station_latitude")),
            TO_GEOGRAPHY(ST_MAKEPOINT("end_station_longitude", "end_station_latitude"))
        ) AS trip_distance_meters,
        ST_DISTANCE(
            TO_GEOGRAPHY(ST_MAKEPOINT("start_station_longitude", "start_station_latitude")),
            TO_GEOGRAPHY(ST_MAKEPOINT("end_station_longitude", "end_station_latitude"))
        ) / "duration_sec" AS average_speed_m_s
    FROM
        "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_TRIPS"
    WHERE
        ("start_station_id" IN (SELECT "station_id" FROM berkeley_stations)
        OR "end_station_id" IN (SELECT "station_id" FROM berkeley_stations))
        AND "start_station_latitude" IS NOT NULL
        AND "start_station_longitude" IS NOT NULL
        AND "end_station_latitude" IS NOT NULL
        AND "end_station_longitude" IS NOT NULL
        AND "duration_sec" > 0
) sub
WHERE
    trip_distance_meters > 1000;