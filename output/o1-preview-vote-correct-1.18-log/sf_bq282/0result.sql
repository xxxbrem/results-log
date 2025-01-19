WITH
cleaned_trips AS (
  SELECT
    t.*,
    TRY_TO_NUMBER(t."start_station_id") AS "start_station_id_num",
    TRY_TO_NUMBER(t."end_station_id") AS "end_station_id_num"
  FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS t
  WHERE TRY_TO_NUMBER(t."start_station_id") IS NOT NULL
    AND TRY_TO_NUMBER(t."end_station_id") IS NOT NULL
    AND t."start_station_id" <> t."end_station_id"
),
active_stations AS (
  SELECT
    TRY_TO_NUMBER("station_id") AS "station_id_num",
    TRY_TO_NUMBER("council_district") AS "council_district_num"
  FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS
  WHERE "status" = 'active'
    AND TRY_TO_NUMBER("council_district") IS NOT NULL
    AND TRY_TO_NUMBER("station_id") IS NOT NULL
)
SELECT s_start."council_district_num" AS "Council_District"
FROM cleaned_trips t
JOIN active_stations s_start
  ON t."start_station_id_num" = s_start."station_id_num"
JOIN active_stations s_end
  ON t."end_station_id_num" = s_end."station_id_num"
WHERE s_start."council_district_num" = s_end."council_district_num"
GROUP BY s_start."council_district_num"
ORDER BY COUNT(*) DESC NULLS LAST
LIMIT 1;