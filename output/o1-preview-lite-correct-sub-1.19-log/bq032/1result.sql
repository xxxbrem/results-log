WITH per_point AS (
  SELECT 
    sid, 
    name, 
    iso_time, 
    latitude, 
    longitude,
    ST_GEOGPOINT(longitude, latitude) AS point,
    LAG(ST_GEOGPOINT(longitude, latitude)) OVER (PARTITION BY sid ORDER BY iso_time) AS prev_point
  FROM `bigquery-public-data.noaa_hurricanes.hurricanes`
  WHERE `season` = '2020' AND `basin` = 'NA'
),
per_distance AS (
  SELECT
    sid,
    name,
    IF(prev_point IS NOT NULL, ST_DISTANCE(prev_point, point), 0) AS distance_meters
  FROM per_point
),
total_distances AS (
  SELECT
    sid,
    name,
    SUM(distance_meters) AS total_distance_meters
  FROM per_distance
  GROUP BY sid, name
),
ranked_storms AS (
  SELECT
    sid,
    name,
    total_distance_meters,
    ROW_NUMBER() OVER (ORDER BY total_distance_meters DESC) AS rank
  FROM total_distances
),
second_longest_storm AS (
  SELECT sid, name
  FROM ranked_storms
  WHERE rank = 2
),
last_position AS (
  SELECT 
    latitude,
    ROW_NUMBER() OVER (ORDER BY iso_time DESC) AS rn
  FROM per_point
  WHERE sid = (SELECT sid FROM second_longest_storm)
)
SELECT 
  ROUND(last_position.latitude, 4) AS latitude
FROM last_position
WHERE last_position.rn = 1