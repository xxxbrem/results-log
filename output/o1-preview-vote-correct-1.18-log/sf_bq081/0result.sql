SELECT
    sub."region_name",
    sub."trip_id",
    ROUND(sub."duration_sec", 4) AS "duration_sec",
    TO_CHAR(
        CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', TO_TIMESTAMP(sub."start_time" / 1e6)),
        'YYYY-MM-DD HH24:MI:SS'
    ) AS "start_time",
    sub."starting_station_name",
    sub."member_gender"
FROM (
    SELECT
        r."name" AS "region_name",
        t."trip_id",
        t."duration_sec",
        t."start_date" AS "start_time",
        t."start_station_name" AS "starting_station_name",
        t."member_gender",
        ROW_NUMBER() OVER (
            PARTITION BY r."name"
            ORDER BY t."start_date" DESC NULLS LAST
        ) AS rn
    FROM
        "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_TRIPS" t
        JOIN "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO" s
            ON t."start_station_id" = s."station_id"
        JOIN "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_REGIONS" r
            ON s."region_id" = r."region_id"
    WHERE
        t."start_date" BETWEEN 1388534400000000 AND 1514764799000000
) sub
WHERE
    sub.rn = 1;