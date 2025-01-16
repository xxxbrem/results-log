SELECT s_start."council_district" AS "council_district_code", COUNT(*) AS "trip_count"
FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS t
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s_start
  ON TRY_TO_NUMBER(t."start_station_id") = TRY_TO_NUMBER(s_start."station_id")
  AND TRY_TO_NUMBER(t."start_station_id") IS NOT NULL
  AND TRY_TO_NUMBER(s_start."station_id") IS NOT NULL
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s_end
  ON TRY_TO_NUMBER(t."end_station_id") = TRY_TO_NUMBER(s_end."station_id")
  AND TRY_TO_NUMBER(t."end_station_id") IS NOT NULL
  AND TRY_TO_NUMBER(s_end."station_id") IS NOT NULL
WHERE TRY_TO_NUMBER(s_start."council_district") = TRY_TO_NUMBER(s_end."council_district")
  AND TRY_TO_NUMBER(s_start."council_district") IS NOT NULL
  AND TRY_TO_NUMBER(s_end."council_district") IS NOT NULL
  AND t."start_station_id" <> t."end_station_id"
  AND LOWER(s_start."status") = 'active'
  AND LOWER(s_end."status") = 'active'
GROUP BY s_start."council_district"
ORDER BY "trip_count" DESC NULLS LAST
LIMIT 1;