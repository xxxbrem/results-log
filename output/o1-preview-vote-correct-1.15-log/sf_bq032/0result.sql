WITH hurricane_points AS (
    SELECT
        "sid",
        "iso_time",
        "latitude",
        "longitude"
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "season" = '2020'
        AND "basin" = 'NA'
        AND "latitude" IS NOT NULL
        AND "longitude" IS NOT NULL
),
hurricane_distances AS (
    SELECT
        hp.*,
        LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_latitude,
        LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_longitude
    FROM hurricane_points hp
),
hurricane_segment_distances AS (
    SELECT
        "sid",
        ST_DISTANCE(
            TO_GEOGRAPHY('POINT(' || "longitude" || ' ' || "latitude" || ')'),
            TO_GEOGRAPHY('POINT(' || prev_longitude || ' ' || prev_latitude || ')')
        ) AS segment_distance
    FROM hurricane_distances
    WHERE prev_latitude IS NOT NULL AND prev_longitude IS NOT NULL
),
hurricane_total_distances AS (
    SELECT
        "sid",
        SUM(segment_distance) AS total_distance
    FROM hurricane_segment_distances
    GROUP BY "sid"
),
second_longest_hurricane AS (
    SELECT
        "sid"
    FROM hurricane_total_distances
    ORDER BY total_distance DESC NULLS LAST
    LIMIT 1 OFFSET 1
),
final_latitude AS (
    SELECT
        h."latitude"
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES h
    JOIN second_longest_hurricane slh ON h."sid" = slh."sid"
    WHERE h."iso_time" = (
        SELECT MAX("iso_time")
        FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
        WHERE "sid" = h."sid"
    )
)

SELECT ROUND("latitude", 4) AS "latitude" FROM final_latitude;