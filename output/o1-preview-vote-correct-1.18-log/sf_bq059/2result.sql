SELECT
    ROUND(MAX("distance" / "duration_sec"), 4) AS "highest_average_speed_mps"
FROM (
    SELECT
        t."trip_id",
        t."duration_sec",
        ST_DISTANCE(
            ST_MAKEPOINT(t."start_station_longitude", t."start_station_latitude"),
            ST_MAKEPOINT(t."end_station_longitude", t."end_station_latitude")
        ) AS "distance"
    FROM
        SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE."BIKESHARE_TRIPS" t
    WHERE
        (t."start_station_name" LIKE '%Berkeley%' OR t."end_station_name" LIKE '%Berkeley%')
        AND t."duration_sec" > 0
        AND t."start_station_latitude" IS NOT NULL
        AND t."end_station_latitude" IS NOT NULL
) sub
WHERE
    "distance" > 1000;