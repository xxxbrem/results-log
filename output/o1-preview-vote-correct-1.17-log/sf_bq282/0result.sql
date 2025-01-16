SELECT s1."council_district" AS council_district_code
FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS t
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s1
  ON t."start_station_id" = s1."station_id"
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s2
  ON TRY_TO_NUMBER(t."end_station_id") = s2."station_id"
WHERE t."start_station_id" <> TRY_TO_NUMBER(t."end_station_id")
  AND s1."council_district" = s2."council_district"
  AND s1."status" = 'active' AND s2."status" = 'active'
GROUP BY s1."council_district"
ORDER BY COUNT(*) DESC NULLS LAST
LIMIT 1;