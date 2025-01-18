SELECT COUNT(DISTINCT qs."stn") AS "Number_of_weather_stations"
FROM (
    SELECT "stn"
    FROM (
        SELECT "stn", COUNT(*) AS num_days_with_temp
        FROM "NOAA_DATA"."NOAA_GSOD"."GSOD2019"
        WHERE "temp" IS NOT NULL
        GROUP BY "stn"
    ) sd
    WHERE sd.num_days_with_temp >= 329
) qs
JOIN (
    SELECT "usaf"
    FROM "NOAA_DATA"."NOAA_GSOD"."STATIONS"
    WHERE TO_DATE("begin", 'YYYYMMDD') <= TO_DATE('20000101', 'YYYYMMDD')
      AND TO_DATE("end", 'YYYYMMDD') >= TO_DATE('20190630', 'YYYYMMDD')
) fs ON qs."stn" = fs."usaf";