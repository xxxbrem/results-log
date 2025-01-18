WITH hurricane_tracks AS (
    SELECT
        "sid",
        "iso_time",
        "latitude",
        "longitude",
        "wmo_wind",
        LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_latitude,
        LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_longitude
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "season" = '2020' AND "basin" = 'NA'
),
distances AS (
    SELECT
        "sid",
        "iso_time",
        "latitude",
        "longitude",
        "wmo_wind",
        CASE
            WHEN prev_latitude IS NOT NULL AND prev_longitude IS NOT NULL THEN
                ST_DISTANCE(
                    ST_MAKEPOINT("longitude", "latitude"),
                    ST_MAKEPOINT(prev_longitude, prev_latitude)
                )
            ELSE 0
        END AS distance
    FROM hurricane_tracks
),
total_distances AS (
    SELECT
        "sid",
        SUM(distance) AS total_distance
    FROM distances
    GROUP BY "sid"
),
ranked_hurricanes AS (
    SELECT
        "sid",
        total_distance,
        RANK() OVER (ORDER BY total_distance DESC NULLS LAST) AS distance_rank
    FROM total_distances
),
cumulative_distances AS (
    SELECT
        d."sid",
        d."iso_time",
        d."latitude",
        d."longitude",
        SUM(d.distance) OVER (PARTITION BY d."sid" ORDER BY d."iso_time") AS cumulative_distance,
        d."wmo_wind" AS max_wind_speed
    FROM distances d
    JOIN ranked_hurricanes r ON d."sid" = r."sid"
    WHERE r.distance_rank = 3
)
SELECT
    'POINT(' || TO_CHAR("longitude", 'FM999999990.0000') || ' ' || TO_CHAR("latitude", 'FM999999990.0000') || ')' AS geom,
    ROUND(cumulative_distance, 4) AS cumulative_distance,
    CAST(max_wind_speed AS INT) AS max_wind_speed
FROM cumulative_distances
ORDER BY "iso_time";