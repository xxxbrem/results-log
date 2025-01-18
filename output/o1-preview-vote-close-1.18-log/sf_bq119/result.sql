WITH hurricane_segments AS (
    SELECT
        "sid",
        "name",
        "iso_time",
        "latitude",
        "longitude",
        "wmo_wind",
        LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS "prev_latitude",
        LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS "prev_longitude",
        CASE 
            WHEN LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") IS NOT NULL THEN
                ST_DISTANCE(
                    ST_POINT("longitude", "latitude"),
                    ST_POINT(
                        LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time"),
                        LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time")
                    )
                )
            ELSE 0
        END AS "segment_distance"
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE
        "season" = '2020' AND
        "basin" = 'NA'
),
hurricane_totals AS (
    SELECT
        "sid",
        "name",
        SUM("segment_distance") AS "total_distance"
    FROM hurricane_segments
    GROUP BY "sid", "name"
),
hurricane_ranks AS (
    SELECT
        "sid",
        "name",
        "total_distance",
        RANK() OVER (ORDER BY "total_distance" DESC NULLS LAST) AS "distance_rank"
    FROM hurricane_totals
),
third_longest_hurricane AS (
    SELECT "sid", "name"
    FROM hurricane_ranks
    WHERE "distance_rank" = 3
),
hurricane_points AS (
    SELECT
        hs."sid",
        hs."name",
        hs."iso_time",
        hs."latitude",
        hs."longitude",
        hs."wmo_wind",
        hs."segment_distance",
        SUM(hs."segment_distance") OVER (PARTITION BY hs."sid" ORDER BY hs."iso_time") AS "cumulative_distance"
    FROM hurricane_segments hs
    JOIN third_longest_hurricane tlh ON hs."sid" = tlh."sid"
)
SELECT
    'POINT(' || ROUND("longitude", 4) || ' ' || ROUND("latitude", 4) || ')' AS "geom",
    ROUND("cumulative_distance", 4) AS "cumulative_distance",
    "wmo_wind" AS "wind_speed"
FROM hurricane_points
ORDER BY "iso_time";