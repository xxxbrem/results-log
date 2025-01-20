WITH hurricane_points AS (
  SELECT
    sid,
    name,
    iso_time,
    latitude,
    longitude,
    ST_GEOGPOINT(longitude, latitude) AS point
  FROM
    `bigquery-public-data.noaa_hurricanes.hurricanes`
  WHERE
    season = '2020'
    AND basin = 'NA'
    AND track_type = 'main'
),
hurricane_distances AS (
  SELECT
    sid,
    name,
    SUM(ST_DISTANCE(ST_GEOGPOINT(prev_longitude, prev_latitude), point)) AS total_distance
  FROM (
    SELECT
      sid,
      name,
      iso_time,
      point,
      latitude,
      longitude,
      LAG(latitude) OVER (PARTITION BY sid ORDER BY iso_time) AS prev_latitude,
      LAG(longitude) OVER (PARTITION BY sid ORDER BY iso_time) AS prev_longitude
    FROM
      hurricane_points
  )
  WHERE
    prev_latitude IS NOT NULL
    AND prev_longitude IS NOT NULL
  GROUP BY
    sid,
    name
),
hurricane_ranks AS (
  SELECT
    sid,
    name,
    total_distance,
    ROW_NUMBER() OVER (ORDER BY total_distance DESC) AS rn
  FROM
    hurricane_distances
)
SELECT
  ROUND(latitude, 4) AS latitude
FROM
  hurricane_points
WHERE
  sid = (SELECT sid FROM hurricane_ranks WHERE rn = 2)
ORDER BY
  iso_time DESC
LIMIT 1