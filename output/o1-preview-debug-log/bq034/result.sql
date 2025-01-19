SELECT id, name
FROM `bigquery-public-data.ghcn_d.ghcnd_stations`
WHERE ST_Distance(
  ST_GeogPoint(longitude, latitude),
  ST_GeogPoint(-87.6847, 41.8319)
) <= 50000