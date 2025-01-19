WITH hurricane_data AS (
    SELECT "sid", "iso_time", "latitude", "longitude"
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "season" = '2020' AND "basin" = 'NA'
),
hurricane_ordered AS (
    SELECT
        "sid",
        "iso_time",
        "latitude",
        "longitude",
        LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_latitude,
        LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_longitude
    FROM hurricane_data
),
hurricane_distance_per_point AS (
    SELECT
        "sid",
        "iso_time",
        "latitude",
        "longitude",
        CASE 
            WHEN prev_latitude IS NOT NULL AND prev_longitude IS NOT NULL THEN
                ST_DISTANCE(
                    TO_GEOGRAPHY('POINT(' || "longitude" || ' ' || "latitude" || ')'),
                    TO_GEOGRAPHY('POINT(' || prev_longitude || ' ' || prev_latitude || ')')
                )
            ELSE 0
        END AS distance_between_points
    FROM hurricane_ordered
),
hurricane_total_distance AS (
    SELECT
        "sid",
        SUM(distance_between_points) AS total_distance
    FROM hurricane_distance_per_point
    GROUP BY "sid"
),
hurricane_ranked AS (
    SELECT
        "sid",
        total_distance,
        ROW_NUMBER() OVER (ORDER BY total_distance DESC NULLS LAST, "sid" DESC) AS distance_rank
    FROM hurricane_total_distance
),
second_longest_hurricane AS (
    SELECT "sid"
    FROM hurricane_ranked
    WHERE distance_rank = 2
),
final_latitude AS (
    SELECT
        hd."latitude" AS latitude
    FROM hurricane_data hd
    JOIN second_longest_hurricane slh ON hd."sid" = slh."sid"
    WHERE hd."iso_time" = (
        SELECT MAX("iso_time")
        FROM hurricane_data
        WHERE "sid" = slh."sid"
    )
)
SELECT ROUND(latitude, 4) AS latitude
FROM final_latitude;