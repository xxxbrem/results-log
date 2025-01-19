SELECT
    r."name" AS "region_name",
    t."trip_id",
    t."duration_sec",
    TO_TIMESTAMP_NTZ(t."start_date" / 1000000) AS "start_time",
    t."start_station_name",
    t."member_gender"
FROM
    SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_TRIPS t
JOIN
    SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_STATION_INFO s
    ON t."start_station_id" = s."station_id"
JOIN
    SAN_FRANCISCO_PLUS.SAN_FRANCISCO_BIKESHARE.BIKESHARE_REGIONS r
    ON TO_NUMBER(s."region_id") = r."region_id"
WHERE
    t."start_date" BETWEEN 1388534400000000 AND 1514764799000000
QUALIFY
    ROW_NUMBER() OVER (
        PARTITION BY r."region_id" 
        ORDER BY t."start_date" DESC NULLS LAST
    ) = 1;