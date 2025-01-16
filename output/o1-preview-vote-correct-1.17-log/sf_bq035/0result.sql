SELECT
    t."bike_number",
    ROUND(SUM(
        ST_DISTANCE(
            TO_GEOGRAPHY('POINT(' || s."longitude" || ' ' || s."latitude" || ')'),
            TO_GEOGRAPHY('POINT(' || e."longitude" || ' ' || e."latitude" || ')')
        )
    ) / 1000, 4) AS "total_distance_km"
FROM
    SAN_FRANCISCO.SAN_FRANCISCO.BIKESHARE_TRIPS t
JOIN
    SAN_FRANCISCO.SAN_FRANCISCO.BIKESHARE_STATIONS s ON t."start_station_id" = s."station_id"
JOIN
    SAN_FRANCISCO.SAN_FRANCISCO.BIKESHARE_STATIONS e ON t."end_station_id" = e."station_id"
GROUP BY
    t."bike_number"
ORDER BY
    t."bike_number";