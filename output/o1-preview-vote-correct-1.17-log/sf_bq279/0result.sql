SELECT
  y."year",
  COUNT(DISTINCT CASE WHEN s."status" = 'active' THEN s."station_id" END) AS "number_active_stations",
  COUNT(DISTINCT CASE WHEN s."status" = 'closed' THEN s."station_id" END) AS "number_closed_stations"
FROM (
  SELECT 2013 AS "year"
  UNION ALL
  SELECT 2014 AS "year"
) y
CROSS JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s
GROUP BY y."year"
ORDER BY y."year";