SELECT
    "Region_Name",
    "Trip_ID",
    "Duration",
    TO_TIMESTAMP_NTZ("Start_Time" / 1e6) AS "Start_Time",
    "Starting_Station",
    "Member_Gender"
FROM (
    SELECT
        BR."name" AS "Region_Name",
        BT."trip_id" AS "Trip_ID",
        BT."duration_sec" AS "Duration",
        BT."start_date" AS "Start_Time",
        SI."name" AS "Starting_Station",
        BT."member_gender" AS "Member_Gender",
        ROW_NUMBER() OVER (
            PARTITION BY BR."region_id"
            ORDER BY BT."start_date" DESC NULLS LAST
        ) AS rn
    FROM
        "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_TRIPS" BT
    JOIN
        "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO" SI
            ON BT."start_station_id" = SI."station_id"
    JOIN
        "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_REGIONS" BR
            ON SI."region_id" = BR."region_id"
    WHERE
        TO_TIMESTAMP_NTZ(BT."start_date" / 1e6) BETWEEN '2014-01-01 00:00:00' AND '2017-12-31 23:59:59'
) sub
WHERE
    rn = 1;