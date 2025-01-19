SELECT ss."council_district"
FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS t
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS ss
  ON TRY_TO_NUMBER(t."start_station_id") = ss."station_id"
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS es
  ON TRY_TO_NUMBER(t."end_station_id") = es."station_id"
WHERE ss."council_district" = es."council_district"
  AND TRY_TO_NUMBER(t."start_station_id") <> TRY_TO_NUMBER(t."end_station_id")
  AND TRY_TO_NUMBER(t."start_station_id") IS NOT NULL
  AND TRY_TO_NUMBER(t."end_station_id") IS NOT NULL
GROUP BY ss."council_district"
ORDER BY COUNT(*) DESC NULLS LAST
LIMIT 1;