SELECT
    t."bike_number",
    ROUND(SUM(
        ST_DISTANCE(
            ST_MAKEPOINT(s."longitude", s."latitude"),
            ST_MAKEPOINT(e."longitude", e."latitude")
        )
    ), 4) AS "total_distance_meters"
FROM
    "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_TRIPS" t
JOIN
    "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_STATIONS" s
    ON t."start_station_id" = s."station_id"
JOIN
    "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_STATIONS" e
    ON t."end_station_id" = e."station_id"
WHERE
    t."start_station_id" IS NOT NULL AND
    t."end_station_id" IS NOT NULL AND
    s."latitude" IS NOT NULL AND s."longitude" IS NOT NULL AND
    e."latitude" IS NOT NULL AND e."longitude" IS NOT NULL
GROUP BY
    t."bike_number";