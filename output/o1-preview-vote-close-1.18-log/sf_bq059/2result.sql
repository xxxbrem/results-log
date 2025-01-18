SELECT
    ROUND(MAX("speed_mps"), 1) AS "Highest_average_speed_m_per_s"
FROM
(
    SELECT
        "trip_id",
        "duration_sec",
        ROUND(
            6371000 * 2 * ASIN(
                SQRT(
                    POWER(SIN(RADIANS(("end_station_latitude" - "start_station_latitude") / 2)), 2) +
                    COS(RADIANS("start_station_latitude")) * COS(RADIANS("end_station_latitude")) *
                    POWER(SIN(RADIANS(("end_station_longitude" - "start_station_longitude") / 2)), 2)
                )
            ), 4
        ) AS "distance_m",
        ROUND(
            (
                6371000 * 2 * ASIN(
                    SQRT(
                        POWER(SIN(RADIANS(("end_station_latitude" - "start_station_latitude") / 2)), 2) +
                        COS(RADIANS("start_station_latitude")) * COS(RADIANS("end_station_latitude")) *
                        POWER(SIN(RADIANS(("end_station_longitude" - "start_station_longitude") / 2)), 2)
                    )
                )
            ) / NULLIF("duration_sec", 0), 4
        ) AS "speed_mps"
    FROM
        "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_TRIPS"
    WHERE
        (
            "start_station_id" IN (245, 246, 250)
            OR "end_station_id" IN (245, 246, 250)
        )
        AND "start_station_latitude" IS NOT NULL
        AND "start_station_longitude" IS NOT NULL
        AND "end_station_latitude" IS NOT NULL
        AND "end_station_longitude" IS NOT NULL
) sub
WHERE
    "distance_m" > 1000;