WITH hurricane_data AS (
  SELECT sid, iso_time, latitude, longitude
  FROM `bigquery-public-data.noaa_hurricanes.hurricanes`
  WHERE season = '2020' AND basin = 'NA' AND latitude IS NOT NULL AND longitude IS NOT NULL
),
hurricane_with_prev AS (
  SELECT
    sid,
    iso_time,
    latitude,
    longitude,
    LAG(latitude) OVER (PARTITION BY sid ORDER BY iso_time) AS prev_latitude,
    LAG(longitude) OVER (PARTITION BY sid ORDER BY iso_time) AS prev_longitude
  FROM hurricane_data
),
hurricane_distances AS (
  SELECT
    sid,
    SUM(
      ST_DISTANCE(
        ST_GEOGPOINT(longitude, latitude),
        ST_GEOGPOINT(prev_longitude, prev_latitude)
      )
    ) AS total_distance
  FROM hurricane_with_prev
  WHERE prev_latitude IS NOT NULL AND prev_longitude IS NOT NULL
  GROUP BY sid
),
ordered_hurricanes AS (
  SELECT
    sid,
    total_distance,
    ROW_NUMBER() OVER (ORDER BY total_distance DESC) AS rn
  FROM hurricane_distances
)
SELECT ROUND(h.latitude, 4) AS latitude
FROM `bigquery-public-data.noaa_hurricanes.hurricanes` AS h
JOIN ordered_hurricanes AS oh
ON h.sid = oh.sid
WHERE h.season = '2020' AND h.basin = 'NA' AND oh.rn = 2
ORDER BY h.iso_time DESC
LIMIT 1