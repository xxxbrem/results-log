SELECT
    sub."Region_name",
    sub."Trip_ID",
    sub."Ride_duration",
    sub."Start_time",
    sub."Starting_station",
    sub."Rider_gender"
FROM
(
    SELECT
        r."name" AS "Region_name",
        t."trip_id" AS "Trip_ID",
        t."duration_sec" AS "Ride_duration",
        t."start_date" AS "Start_time",
        s."name" AS "Starting_station",
        t."member_gender" AS "Rider_gender",
        ROW_NUMBER() OVER (
            PARTITION BY s."region_id"
            ORDER BY t."start_date" DESC NULLS LAST
        ) AS rn
    FROM
        SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_TRIPS t
    JOIN
        SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_STATION_INFO s
            ON t."start_station_id" = s."station_id"
    JOIN
        SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_REGIONS r
            ON s."region_id" = r."region_id"
    WHERE
        t."start_date" BETWEEN 1388534400000000 AND 1514764799000000
) sub
WHERE
    sub.rn = 1;