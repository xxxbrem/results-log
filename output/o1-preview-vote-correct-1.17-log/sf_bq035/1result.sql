SELECT
    t."bike_number",
    ROUND(
        SUM(
            HAVERSINE(
                s_start."longitude", s_start."latitude",
                s_end."longitude", s_end."latitude"
            ) * 0.000621371
        ),
        4
    ) AS "total_distance"
FROM
    "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_TRIPS" t
JOIN
    "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_STATIONS" s_start
    ON t."start_station_id" = s_start."station_id"
JOIN
    "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_STATIONS" s_end
    ON t."end_station_id" = s_end."station_id"
WHERE
    s_start."latitude" IS NOT NULL
    AND s_start."longitude" IS NOT NULL
    AND s_end."latitude" IS NOT NULL
    AND s_end."longitude" IS NOT NULL
GROUP BY
    t."bike_number";