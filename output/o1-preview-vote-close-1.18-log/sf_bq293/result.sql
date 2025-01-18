WITH trip_data AS (
    SELECT
        z."zip_code",
        TO_DATE(TO_TIMESTAMP(t."pickup_datetime" / 1e6)) AS "pickup_date",
        EXTRACT(HOUR FROM TO_TIMESTAMP(t."pickup_datetime" / 1e6)) AS "pickup_hour",
        COUNT(*) AS "ride_count"
    FROM (
        SELECT * FROM "NEW_YORK_GEO"."NEW_YORK"."TLC_YELLOW_TRIPS_2014"
        UNION ALL
        SELECT * FROM "NEW_YORK_GEO"."NEW_YORK"."TLC_YELLOW_TRIPS_2015"
    ) t
    JOIN "NEW_YORK_GEO"."GEO_US_BOUNDARIES"."ZIP_CODES" z
        ON ST_CONTAINS(
            ST_GEOGFROMWKB(z."zip_code_geom"),
            ST_POINT(t."pickup_longitude", t."pickup_latitude")
        )
    WHERE TO_DATE(TO_TIMESTAMP(t."pickup_datetime" / 1e6)) BETWEEN '2014-12-10' AND '2015-01-01'
      AND t."pickup_longitude" BETWEEN -75 AND -72
      AND t."pickup_latitude" BETWEEN 40 AND 41
      AND t."pickup_longitude" IS NOT NULL
      AND t."pickup_latitude" IS NOT NULL
    GROUP BY z."zip_code", "pickup_date", "pickup_hour"
),
jan1_data AS (
    SELECT *
    FROM trip_data
    WHERE "pickup_date" = '2015-01-01'
),
lagged_data AS (
    SELECT
        jd."zip_code",
        jd."pickup_hour",
        jd."ride_count",
        hl."ride_count" AS "Hourly_lagged_count",
        dl."ride_count" AS "Daily_lagged_count",
        wl."ride_count" AS "Weekly_lagged_count"
    FROM jan1_data jd
    LEFT JOIN trip_data hl
        ON jd."zip_code" = hl."zip_code"
        AND (
            (jd."pickup_hour" = 0 AND hl."pickup_date" = DATEADD('day', -1, jd."pickup_date") AND hl."pickup_hour" = 23)
            OR
            (jd."pickup_hour" > 0 AND hl."pickup_date" = jd."pickup_date" AND hl."pickup_hour" = jd."pickup_hour" - 1)
        )
    LEFT JOIN trip_data dl
        ON jd."zip_code" = dl."zip_code"
        AND dl."pickup_date" = DATEADD('day', -1, jd."pickup_date")
        AND dl."pickup_hour" = jd."pickup_hour"
    LEFT JOIN trip_data wl
        ON jd."zip_code" = wl."zip_code"
        AND wl."pickup_date" = DATEADD('day', -7, jd."pickup_date")
        AND wl."pickup_hour" = jd."pickup_hour"
),
stats_data AS (
    SELECT
        ld.*,
        avg14."14_day_avg_ride_counts",
        std14."14_day_stddev_ride_counts",
        avg21."21_day_avg_ride_counts",
        std21."21_day_stddev_ride_counts"
    FROM lagged_data ld
    LEFT JOIN (
        SELECT
            "zip_code",
            "pickup_hour",
            AVG("ride_count") AS "14_day_avg_ride_counts"
        FROM trip_data
        WHERE "pickup_date" BETWEEN DATEADD('day', -14, '2015-01-01') AND DATEADD('day', -1, '2015-01-01')
        GROUP BY "zip_code", "pickup_hour"
    ) avg14
        ON ld."zip_code" = avg14."zip_code" AND ld."pickup_hour" = avg14."pickup_hour"
    LEFT JOIN (
        SELECT
            "zip_code",
            "pickup_hour",
            STDDEV("ride_count") AS "14_day_stddev_ride_counts"
        FROM trip_data
        WHERE "pickup_date" BETWEEN DATEADD('day', -14, '2015-01-01')
            AND DATEADD('day', -1, '2015-01-01')
        GROUP BY "zip_code", "pickup_hour"
    ) std14
        ON ld."zip_code" = std14."zip_code" AND ld."pickup_hour" = std14."pickup_hour"
    LEFT JOIN (
        SELECT
            "zip_code",
            "pickup_hour",
            AVG("ride_count") AS "21_day_avg_ride_counts"
        FROM trip_data
        WHERE "pickup_date" BETWEEN DATEADD('day', -21, '2015-01-01') AND DATEADD('day', -1, '2015-01-01')
        GROUP BY "zip_code", "pickup_hour"
    ) avg21
        ON ld."zip_code" = avg21."zip_code" AND ld."pickup_hour" = avg21."pickup_hour"
    LEFT JOIN (
        SELECT
            "zip_code",
            "pickup_hour",
            STDDEV("ride_count") AS "21_day_stddev_ride_counts"
        FROM trip_data
        WHERE "pickup_date" BETWEEN DATEADD('day', -21, '2015-01-01') AND DATEADD('day', -1, '2015-01-01')
        GROUP BY "zip_code", "pickup_hour"
    ) std21
        ON ld."zip_code" = std21."zip_code" AND ld."pickup_hour" = std21."pickup_hour"
)
SELECT
    "zip_code" AS "ZIP_code",
    "pickup_hour" AS "Hour",
    "ride_count" AS "Count_of_rides",
    COALESCE("Hourly_lagged_count", 0) AS "Hourly_lagged_count",
    COALESCE("Daily_lagged_count", 0) AS "Daily_lagged_count",
    COALESCE("Weekly_lagged_count", 0) AS "Weekly_lagged_count",
    ROUND("14_day_avg_ride_counts", 4) AS "14_day_avg_ride_counts",
    ROUND("14_day_stddev_ride_counts", 4) AS "14_day_stddev_ride_counts",
    ROUND("21_day_avg_ride_counts", 4) AS "21_day_avg_ride_counts",
    ROUND("21_day_stddev_ride_counts", 4) AS "21_day_stddev_ride_counts"
FROM stats_data
ORDER BY "ride_count" DESC NULLS LAST
LIMIT 5;