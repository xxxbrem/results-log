WITH hurricane_points AS (
  SELECT 
    "sid", 
    "iso_time", 
    "latitude", 
    "longitude",
    LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_latitude,
    LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS prev_longitude
  FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
  WHERE "season" = '2020' AND "basin" = 'NA'
),
hurricane_distances AS (
  SELECT 
    "sid",
    CASE 
      WHEN prev_latitude IS NULL OR prev_longitude IS NULL THEN 0
      ELSE ST_DISTANCE(
             ST_GeographyFromText('POINT(' || "longitude" || ' ' || "latitude" || ')'),
             ST_GeographyFromText('POINT(' || prev_longitude || ' ' || prev_latitude || ')'))
    END AS distance
  FROM hurricane_points
),
hurricane_totals AS (
  SELECT 
    "sid",
    SUM(distance) AS total_distance
  FROM hurricane_distances
  GROUP BY "sid"
),
second_longest AS (
  SELECT 
    "sid"
  FROM hurricane_totals
  ORDER BY total_distance DESC NULLS LAST
  LIMIT 1 OFFSET 1
),
final_point AS (
  SELECT 
    h."latitude"
  FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES h
  JOIN second_longest sl ON h."sid" = sl."sid"
  WHERE h."iso_time" = (
    SELECT MAX("iso_time")
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES
    WHERE "sid" = h."sid"
  )
)
SELECT ROUND("latitude", 4) AS "latitude" FROM final_point;