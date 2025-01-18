SELECT
    ROUND(MAX(sub.avg_speed), 1) AS "Highest_average_speed_m_per_s"
FROM (
    SELECT
        t."trip_id",
        t."duration_sec",
        (
            6371000 * 2 * ASIN(SQRT(
                POWER(SIN(RADIANS(t."end_station_latitude" - t."start_station_latitude") / 2), 2)
                + COS(RADIANS(t."start_station_latitude")) * COS(RADIANS(t."end_station_latitude"))
                * POWER(SIN(RADIANS(t."end_station_longitude" - t."start_station_longitude") / 2), 2)
            ))
        ) AS distance,
        (
            (
                6371000 * 2 * ASIN(SQRT(
                    POWER(SIN(RADIANS(t."end_station_latitude" - t."start_station_latitude") / 2), 2)
                    + COS(RADIANS(t."start_station_latitude")) * COS(RADIANS(t."end_station_latitude"))
                    * POWER(SIN(RADIANS(t."end_station_longitude" - t."start_station_longitude") / 2), 2)
                ))
            ) / NULLIF(t."duration_sec", 0)
        ) AS avg_speed
    FROM
        "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_TRIPS" t
    WHERE
        t."duration_sec" > 0
        AND t."start_station_latitude" IS NOT NULL
        AND t."start_station_longitude" IS NOT NULL
        AND t."end_station_latitude" IS NOT NULL
        AND t."end_station_longitude" IS NOT NULL
        AND (
            t."start_station_id" IN (
                SELECT "station_id"
                FROM "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO"
                WHERE "region_id" = 14
            )
            OR
            t."end_station_id" IN (
                SELECT "station_id"
                FROM "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO"
                WHERE "region_id" = 14
            )
        )
) sub
WHERE
    sub.distance > 1000
    AND sub.avg_speed IS NOT NULL
;