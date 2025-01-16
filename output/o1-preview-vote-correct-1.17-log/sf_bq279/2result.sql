SELECT
    year,
    COUNT(DISTINCT CASE WHEN s."status" = 'active' THEN s."station_id" END) AS number_active,
    COUNT(DISTINCT CASE WHEN s."status" = 'closed' THEN s."station_id" END) AS number_closed
FROM (
    SELECT
        EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ(t."start_time" / 1e6)) AS year,
        t."start_station_id" AS station_id
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS t
    WHERE EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ(t."start_time" / 1e6)) IN (2013, 2014)
) AS trips_by_year
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s
    ON trips_by_year.station_id = s."station_id"
GROUP BY year
ORDER BY year;