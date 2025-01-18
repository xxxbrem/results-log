WITH hurricane_points AS (
    SELECT 
        "sid", 
        "iso_time", 
        "latitude", 
        "longitude", 
        "wmo_wind",
        ST_MAKEPOINT("longitude", "latitude") AS geom,
        LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_latitude,
        LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_longitude
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "season" = '2020' AND "basin" = 'NA'
),
hurricane_distances AS (
    SELECT 
        "sid",
        "iso_time",
        "latitude",
        "longitude",
        "wmo_wind",
        geom,
        CASE 
            WHEN prev_latitude IS NOT NULL THEN
                ST_DISTANCE(
                    ST_MAKEPOINT("longitude", "latitude"),
                    ST_MAKEPOINT(prev_longitude, prev_latitude)
                )
            ELSE 0 
        END AS distance
    FROM hurricane_points
),
total_distances AS (
    SELECT 
        "sid",
        SUM(distance) AS total_distance
    FROM hurricane_distances
    GROUP BY "sid"
),
ordered_distances AS (
    SELECT 
        "sid", 
        total_distance,
        ROW_NUMBER() OVER (ORDER BY total_distance DESC NULLS LAST) AS rn
    FROM total_distances
),
selected_sid AS (
    SELECT "sid"
    FROM ordered_distances
    WHERE rn = 3
),
selected_hurricane AS (
    SELECT 
        h."iso_time",
        h.geom,
        SUM(h.distance) OVER (
            PARTITION BY h."sid" 
            ORDER BY h."iso_time" 
            ROWS UNBOUNDED PRECEDING
        ) AS cumulative_distance,
        h."wmo_wind"
    FROM hurricane_distances h
    WHERE h."sid" = (SELECT "sid" FROM selected_sid)
),
final_output AS (
    SELECT
        ST_ASWKT(geom) AS geom,
        ROUND(cumulative_distance, 4) AS cumulative_distance,
        "wmo_wind"
    FROM selected_hurricane
    ORDER BY "iso_time"
)
SELECT *
FROM final_output;