WITH valid_day_counts AS (
  SELECT "stn", "wban", COUNT(DISTINCT "mo", "da") AS valid_days
  FROM "NOAA_DATA"."NOAA_GSOD"."GSOD2019"
  WHERE "temp" IS NOT NULL
  GROUP BY "stn", "wban"
),
max_days AS (
  SELECT MAX(valid_days) AS max_valid_days
  FROM valid_day_counts
),
stations_above_90_percent AS (
  SELECT vdc."stn", vdc."wban"
  FROM valid_day_counts vdc
  CROSS JOIN max_days
  WHERE vdc.valid_days >= 0.9 * max_valid_days
),
stations_with_dates AS (
  SELECT sap."stn", sap."wban", s."begin", s."end"
  FROM stations_above_90_percent sap
  JOIN "NOAA_DATA"."NOAA_GSOD"."STATIONS" s
    ON sap."stn" = s."usaf" AND sap."wban" = s."wban"
)
SELECT COUNT(*) AS number_of_stations
FROM stations_with_dates swd
WHERE TO_DATE(swd."begin", 'YYYYMMDD') <= TO_DATE('20000101', 'YYYYMMDD')
  AND TO_DATE(swd."end", 'YYYYMMDD') >= TO_DATE('20190630', 'YYYYMMDD');