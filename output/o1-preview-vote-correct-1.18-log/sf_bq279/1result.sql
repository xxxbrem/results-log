SELECT
  "Year",
  MAX(CASE WHEN "status" = 'active' THEN "Station_Count" ELSE 0 END) AS "Active_Stations",
  MAX(CASE WHEN "status" = 'closed' THEN "Station_Count" ELSE 0 END) AS "Closed_Stations"
FROM (
  SELECT
    EXTRACT(year FROM TO_TIMESTAMP_NTZ(t."start_time" / 1000000)) AS "Year",
    s."status",
    COUNT(DISTINCT t."start_station_id") AS "Station_Count"
  FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS t
  JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s
    ON t."start_station_id" = s."station_id"
  WHERE EXTRACT(year FROM TO_TIMESTAMP_NTZ(t."start_time" / 1000000)) BETWEEN 2013 AND 2014
  GROUP BY "Year", s."status"
) sub
GROUP BY "Year"
ORDER BY "Year";