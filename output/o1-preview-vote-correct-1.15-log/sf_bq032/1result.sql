WITH hurricane_positions AS (
  SELECT
    "sid",
    "iso_time",
    "latitude",
    "longitude",
    LAG("latitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS "prev_latitude",
    LAG("longitude") OVER (PARTITION BY "sid" ORDER BY "iso_time") AS "prev_longitude"
  FROM "NOAA_DATA"."NOAA_HURRICANES"."HURRICANES"
  WHERE "season" = '2020' AND "basin" = 'NA'
),
hurricane_distances AS (
  SELECT
    "sid",
    CASE
      WHEN "prev_latitude" IS NOT NULL AND "prev_longitude" IS NOT NULL THEN
        ST_DISTANCE(
          ST_MAKEPOINT("longitude", "latitude"),
          ST_MAKEPOINT("prev_longitude", "prev_latitude")
        )
      ELSE 0
    END AS "distance"
  FROM hurricane_positions
),
total_distances AS (
  SELECT
    "sid",
    SUM("distance") AS "total_distance"
  FROM hurricane_distances
  GROUP BY "sid"
),
ranked_hurricanes AS (
  SELECT
    "sid",
    "total_distance",
    RANK() OVER (ORDER BY "total_distance" DESC NULLS LAST) AS "rank"
  FROM total_distances
)
SELECT ROUND(hp_final."latitude", 4) AS "final_latitude"
FROM ranked_hurricanes rh
JOIN (
  SELECT
    "sid",
    "latitude",
    ROW_NUMBER() OVER (PARTITION BY "sid" ORDER BY "iso_time" DESC) AS rn
  FROM "NOAA_DATA"."NOAA_HURRICANES"."HURRICANES"
  WHERE "season" = '2020' AND "basin" = 'NA'
) hp_final ON rh."sid" = hp_final."sid" AND hp_final.rn = 1
WHERE rh."rank" = 2;