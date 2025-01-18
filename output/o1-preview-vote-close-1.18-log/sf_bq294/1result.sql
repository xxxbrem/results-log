SELECT
  BIKESHARE_TRIPS."trip_id",
  BIKESHARE_TRIPS."duration_sec" AS "duration_seconds",
  TO_CHAR(TO_TIMESTAMP( BIKESHARE_TRIPS."start_date" / 1000000 ), 'YYYY-MM-DD HH24:MI:SS') AS "start_date",
  BIKESHARE_TRIPS."start_station_name",
  CONCAT( BIKESHARE_TRIPS."start_station_name", ' - ', BIKESHARE_TRIPS."end_station_name" ) AS "route",
  BIKESHARE_TRIPS."bike_number",
  BIKESHARE_TRIPS."subscriber_type",
  BIKESHARE_TRIPS."member_birth_year",
  (2017 - BIKESHARE_TRIPS."member_birth_year") AS "current_age",
  CASE
    WHEN (2017 - BIKESHARE_TRIPS."member_birth_year") < 40 THEN 'Young (<40 Y.O)'
    WHEN (2017 - BIKESHARE_TRIPS."member_birth_year") BETWEEN 40 AND 60 THEN 'Adult (40-60 Y.O)'
    ELSE 'Senior Adult (>60 Y.O)'
  END AS "age_classification",
  BIKESHARE_TRIPS."member_gender" AS "gender",
  BIKESHARE_REGIONS."name" AS "region_name"
FROM
  SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_TRIPS
JOIN
  SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_STATION_INFO
    ON BIKESHARE_TRIPS."start_station_id" = BIKESHARE_STATION_INFO."station_id"
JOIN
  SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_REGIONS
    ON BIKESHARE_STATION_INFO."region_id" = BIKESHARE_REGIONS."region_id"
WHERE
  BIKESHARE_TRIPS."start_station_name" IS NOT NULL
  AND BIKESHARE_TRIPS."start_station_name" <> ''
  AND BIKESHARE_TRIPS."member_birth_year" IS NOT NULL
  AND BIKESHARE_TRIPS."member_birth_year" > 0
  AND BIKESHARE_TRIPS."member_gender" IS NOT NULL
  AND BIKESHARE_TRIPS."member_gender" <> ''
  AND BIKESHARE_TRIPS."start_date" IS NOT NULL
  AND TO_TIMESTAMP( BIKESHARE_TRIPS."start_date" / 1000000 ) >= TO_TIMESTAMP('2017-07-01', 'YYYY-MM-DD')
  AND TO_TIMESTAMP( BIKESHARE_TRIPS."start_date" / 1000000 ) < TO_TIMESTAMP('2018-01-01', 'YYYY-MM-DD')
ORDER BY
  BIKESHARE_TRIPS."duration_sec" DESC NULLS LAST
LIMIT 5;