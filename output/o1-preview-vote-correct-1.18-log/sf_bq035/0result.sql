SELECT
  t."bike_number",
  ROUND(SUM(
    2 * 6371 * ASIN(
      SQRT(
        POWER(SIN(RADIANS(s_end."latitude" - s_start."latitude") / 2), 2) +
        COS(RADIANS(s_start."latitude")) * COS(RADIANS(s_end."latitude")) *
        POWER(SIN(RADIANS(s_end."longitude" - s_start."longitude") / 2), 2)
      )
    )
  ), 4) AS "total_distance"
FROM
  "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_TRIPS" t
  JOIN "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_STATIONS" s_start
    ON t."start_station_id" = s_start."station_id"
  JOIN "SAN_FRANCISCO"."SAN_FRANCISCO"."BIKESHARE_STATIONS" s_end
    ON t."end_station_id" = s_end."station_id"
WHERE
  s_start."latitude" IS NOT NULL
  AND s_start."longitude" IS NOT NULL
  AND s_end."latitude" IS NOT NULL
  AND s_end."longitude" IS NOT NULL
  AND t."bike_number" IS NOT NULL
GROUP BY
  t."bike_number"
ORDER BY
  t."bike_number" ASC;