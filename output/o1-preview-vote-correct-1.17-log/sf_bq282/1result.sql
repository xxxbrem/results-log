WITH valid_stations AS (
  SELECT
    TRY_TO_NUMBER("station_id") AS station_id_num,
    TRY_TO_NUMBER("council_district") AS council_district_num
  FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS
  WHERE TRY_TO_NUMBER("station_id") IS NOT NULL
    AND TRY_TO_NUMBER("council_district") IS NOT NULL
),
valid_trips AS (
  SELECT
    TRY_TO_NUMBER("start_station_id") AS start_station_id_num,
    TRY_TO_NUMBER("end_station_id") AS end_station_id_num
  FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
  WHERE TRY_TO_NUMBER("start_station_id") IS NOT NULL
    AND TRY_TO_NUMBER("end_station_id") IS NOT NULL
    AND "start_station_id" <> "end_station_id"
)
SELECT s1.council_district_num AS "council_district"
FROM valid_trips t
JOIN valid_stations s1 ON t.start_station_id_num = s1.station_id_num
JOIN valid_stations s2 ON t.end_station_id_num = s2.station_id_num
WHERE s1.council_district_num = s2.council_district_num
GROUP BY s1.council_district_num
ORDER BY COUNT(*) DESC NULLS LAST
LIMIT 1;