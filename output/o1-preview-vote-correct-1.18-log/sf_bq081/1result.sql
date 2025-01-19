WITH trip_data AS (
    SELECT
        regions."name" AS "region_name",
        trips."trip_id",
        trips."duration_sec",
        trips."start_date",
        trips."start_station_name",
        trips."member_gender",
        ROW_NUMBER() OVER (
            PARTITION BY regions."region_id"
            ORDER BY trips."start_date" DESC NULLS LAST
        ) AS rn
    FROM
        "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_TRIPS" trips
        JOIN "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO" stations 
            ON trips."start_station_id" = stations."station_id"
        JOIN "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_REGIONS" regions 
            ON stations."region_id" = regions."region_id"
    WHERE
        trips."start_date" BETWEEN 1388534400000000 AND 1514678400000000
)
SELECT
    "region_name",
    "trip_id",
    "duration_sec",
    "start_date",
    "start_station_name",
    "member_gender"
FROM
    trip_data
WHERE
    rn = 1
ORDER BY
    "region_name";