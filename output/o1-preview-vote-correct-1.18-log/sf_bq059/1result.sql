SELECT
    ROUND(MAX(average_speed_m_per_s), 1) AS "Highest_average_speed_m_per_s"
FROM (
    SELECT
        ROUND((trip_distance / t."duration_sec"), 4) AS average_speed_m_per_s
    FROM (
        SELECT
            t."trip_id",
            t."duration_sec",
            ST_DISTANCE(
                ST_MAKEPOINT(t."start_station_longitude", t."start_station_latitude"),
                ST_MAKEPOINT(t."end_station_longitude", t."end_station_latitude")
            ) AS trip_distance
        FROM "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_TRIPS" t
        WHERE
            t."duration_sec" > 0
            AND t."start_station_latitude" IS NOT NULL
            AND t."start_station_longitude" IS NOT NULL
            AND t."end_station_latitude" IS NOT NULL
            AND t."end_station_longitude" IS NOT NULL
            AND (
                t."start_station_id" IN (
                    SELECT s."station_id"
                    FROM "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO" s
                    JOIN "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_REGIONS" r
                        ON s."region_id" = r."region_id"
                    WHERE r."name" = 'Berkeley'
                )
                OR
                t."end_station_id" IN (
                    SELECT s."station_id"
                    FROM "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO" s
                    JOIN "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_REGIONS" r
                        ON s."region_id" = r."region_id"
                    WHERE r."name" = 'Berkeley'
                )
            )
    ) t
    WHERE trip_distance > 1000
) sub;