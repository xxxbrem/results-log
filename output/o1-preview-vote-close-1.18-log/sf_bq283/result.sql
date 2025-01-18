WITH "active_stations" AS (
    SELECT "station_id"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS
    WHERE "status" = 'active'
),
"total_trips_active" AS (
    SELECT COUNT(*) AS "total_trips"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS AS "trips"
    JOIN "active_stations" AS "stations"
    ON "trips"."start_station_id" = "stations"."station_id"
    WHERE "trips"."start_station_id" IS NOT NULL AND "trips"."duration_minutes" > 0
),
"station_trip_counts" AS (
    SELECT "trips"."start_station_id" AS "station_id",
           COUNT(*) AS "total_trips",
           AVG("trips"."duration_minutes") AS "average_duration"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS AS "trips"
    JOIN "active_stations" AS "stations"
    ON "trips"."start_station_id" = "stations"."station_id"
    WHERE "trips"."start_station_id" IS NOT NULL AND "trips"."duration_minutes" > 0
    GROUP BY "trips"."start_station_id"
)
SELECT
    "station_trip_counts"."station_id",
    "station_trip_counts"."total_trips",
    ROUND(("station_trip_counts"."total_trips" / "total_trips_active"."total_trips") * 100, 4) AS "percentage_of_total_trips",
    ROUND("station_trip_counts"."average_duration", 4) AS "average_duration"
FROM
    "station_trip_counts", "total_trips_active"
ORDER BY
    "station_trip_counts"."total_trips" DESC NULLS LAST
LIMIT 15;