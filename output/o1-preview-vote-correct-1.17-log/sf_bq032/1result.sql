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
distance_calculations AS (
    SELECT
        "sid",
        ST_DISTANCE(
            TO_GEOGRAPHY('POINT(' || "longitude" || ' ' || "latitude" || ')'),
            TO_GEOGRAPHY('POINT(' || "prev_longitude" || ' ' || "prev_latitude" || ')')
        ) AS "segment_distance"
    FROM hurricane_points
    WHERE "prev_latitude" IS NOT NULL AND "prev_longitude" IS NOT NULL
),
total_distances AS (
    SELECT
        "sid",
        SUM("segment_distance") AS "total_distance"
    FROM distance_calculations
    GROUP BY "sid"
),
second_longest_sid AS (
    SELECT "sid"
    FROM total_distances
    ORDER BY "total_distance" DESC NULLS LAST
    LIMIT 1 OFFSET 1
)
SELECT ROUND(h."latitude", 4) AS latitude
FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES h
WHERE h."sid" = (SELECT "sid" FROM second_longest_sid)
AND h."iso_time" = (
    SELECT MAX("iso_time")
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "sid" = h."sid"
)
LIMIT 1;