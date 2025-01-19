WITH hurricane_points AS (
    SELECT
        "sid",
        "iso_time",
        "latitude",
        "longitude",
        LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS "prev_latitude",
        LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS "prev_longitude"
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "season" = '2020' AND "basin" = 'NA'
),
hurricane_segments AS (
    SELECT
        "sid",
        CASE 
            WHEN "latitude" IS NOT NULL AND "longitude" IS NOT NULL 
                 AND "prev_latitude" IS NOT NULL AND "prev_longitude" IS NOT NULL
            THEN ST_DISTANCE(
                TO_GEOGRAPHY(ST_POINT("longitude", "latitude")),
                TO_GEOGRAPHY(ST_POINT("prev_longitude", "prev_latitude"))
            )
            ELSE 0
        END AS "segment_distance"
    FROM hurricane_points
),
total_distances AS (
    SELECT
        "sid",
        SUM("segment_distance") AS "total_distance"
    FROM hurricane_segments
    GROUP BY "sid"
),
ranked_hurricanes AS (
    SELECT
        "sid",
        "total_distance",
        RANK() OVER (ORDER BY "total_distance" DESC NULLS LAST) AS "distance_rank"
    FROM total_distances
),
final_positions AS (
    SELECT
        "sid",
        "latitude",
        "iso_time",
        ROW_NUMBER() OVER (PARTITION BY "sid" ORDER BY "iso_time" DESC NULLS LAST) AS rn
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "season" = '2020' AND "basin" = 'NA'
)
SELECT
    ROUND(fp."latitude", 4) AS "latitude"
FROM
    ranked_hurricanes rh
    JOIN final_positions fp ON rh."sid" = fp."sid"
WHERE
    rh."distance_rank" = 2
    AND fp.rn = 1;