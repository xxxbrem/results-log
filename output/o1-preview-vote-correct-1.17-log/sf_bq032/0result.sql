WITH hurricane_data AS (
    SELECT
        "sid",
        "iso_time",
        ROUND("latitude", 4) AS "latitude",
        "longitude",
        LAG("latitude") OVER (
            PARTITION BY "sid" ORDER BY "iso_time"
        ) AS "prev_latitude",
        LAG("longitude") OVER (
            PARTITION BY "sid" ORDER BY "iso_time"
        ) AS "prev_longitude"
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "season" = '2020' AND "basin" = 'NA'
      AND "latitude" IS NOT NULL AND "longitude" IS NOT NULL
),
distance_data AS (
    SELECT
        "sid",
        ST_DISTANCE(
            ST_MAKEPOINT("longitude", "latitude"),
            ST_MAKEPOINT("prev_longitude", "prev_latitude")
        ) AS "segment_distance"
    FROM hurricane_data
    WHERE "prev_latitude" IS NOT NULL AND "prev_longitude" IS NOT NULL
),
total_distance AS (
    SELECT
        "sid",
        SUM("segment_distance") AS "total_distance"
    FROM distance_data
    GROUP BY "sid"
),
second_longest_hurricane AS (
    SELECT "sid"
    FROM (
        SELECT
            "sid",
            "total_distance",
            ROW_NUMBER() OVER (ORDER BY "total_distance" DESC NULLS LAST) AS rn
        FROM total_distance
    ) ranked_hurricanes
    WHERE rn = 2
),
final_latitude AS (
    SELECT
        ROUND(h."latitude", 4) AS "latitude"
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES h
    JOIN second_longest_hurricane s ON h."sid" = s."sid"
    WHERE h."iso_time" = (
        SELECT MAX("iso_time")
        FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
        WHERE "sid" = s."sid"
    )
)
SELECT "latitude" FROM final_latitude;