SELECT
    "bike_number",
    ROUND(SUM(distance), 4) AS total_distance
FROM (
    SELECT
        t."bike_number",
        6371 * 2 * ATAN2(
            SQRT(
                SIN(RADIANS((s_end."latitude" - s_start."latitude") / 2)) * SIN(RADIANS((s_end."latitude" - s_start."latitude") / 2)) +
                COS(RADIANS(s_start."latitude")) * COS(RADIANS(s_end."latitude")) *
                SIN(RADIANS((s_end."longitude" - s_start."longitude") / 2)) * SIN(RADIANS((s_end."longitude" - s_start."longitude") / 2))
            ),
            SQRT(
                1 - (
                    SIN(RADIANS((s_end."latitude" - s_start."latitude") / 2)) * SIN(RADIANS((s_end."latitude" - s_start."latitude") / 2)) +
                    COS(RADIANS(s_start."latitude")) * COS(RADIANS(s_end."latitude")) *
                    SIN(RADIANS((s_end."longitude" - s_start."longitude") / 2)) * SIN(RADIANS((s_end."longitude" - s_start."longitude") / 2))
                )
            )
        ) AS distance
    FROM SAN_FRANCISCO.SAN_FRANCISCO."BIKESHARE_TRIPS" t
    INNER JOIN SAN_FRANCISCO.SAN_FRANCISCO."BIKESHARE_STATIONS" s_start
        ON t."start_station_id" = s_start."station_id"
    INNER JOIN SAN_FRANCISCO.SAN_FRANCISCO."BIKESHARE_STATIONS" s_end
        ON t."end_station_id" = s_end."station_id"
    WHERE s_start."latitude" IS NOT NULL
      AND s_start."longitude" IS NOT NULL
      AND s_end."latitude" IS NOT NULL
      AND s_end."longitude" IS NOT NULL
) trip_distances
GROUP BY "bike_number"
ORDER BY "bike_number";