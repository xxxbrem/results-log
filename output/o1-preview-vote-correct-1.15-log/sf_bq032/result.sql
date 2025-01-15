WITH hurricane_data AS (
    SELECT 
        "sid",
        "iso_time",
        "latitude",
        "longitude"
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE 
        "season" = '2020'
        AND "basin" = 'NA'
        AND "latitude" IS NOT NULL
        AND "longitude" IS NOT NULL
        AND "iso_time" IS NOT NULL
        AND "sid" IS NOT NULL
),
hurricane_points AS (
    SELECT
        "sid",
        "iso_time",
        "latitude",
        "longitude",
        LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time" NULLS LAST) AS "prev_latitude",
        LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time" NULLS LAST) AS "prev_longitude"
    FROM hurricane_data
),
hurricane_distances AS (
    SELECT
        "sid",
        "iso_time",
        "latitude",
        "longitude",
        "prev_latitude",
        "prev_longitude",
        CASE
            WHEN "prev_latitude" IS NOT NULL AND "prev_longitude" IS NOT NULL THEN
                ST_DISTANCE(
                    TO_GEOGRAPHY('POINT(' || "longitude" || ' ' || "latitude" || ')'),
                    TO_GEOGRAPHY('POINT(' || "prev_longitude" || ' ' || "prev_latitude" || ')')
                )
            ELSE 0
        END AS "segment_distance"
    FROM hurricane_points
),
hurricane_total_distances AS (
    SELECT
        "sid",
        SUM("segment_distance") AS "total_distance_meters"
    FROM hurricane_distances
    GROUP BY "sid"
),
hurricane_ranks AS (
    SELECT
        "sid",
        "total_distance_meters",
        RANK() OVER (ORDER BY "total_distance_meters" DESC NULLS LAST) AS "distance_rank"
    FROM hurricane_total_distances
),
second_longest_hurricane AS (
    SELECT "sid"
    FROM hurricane_ranks
    WHERE "distance_rank" = 2
)
SELECT
    ROUND(hd."latitude", 4) AS "latitude"
FROM hurricane_data hd
JOIN second_longest_hurricane slh ON hd."sid" = slh."sid"
WHERE hd."iso_time" = (
    SELECT MAX("iso_time") FROM hurricane_data WHERE "sid" = slh."sid"
)