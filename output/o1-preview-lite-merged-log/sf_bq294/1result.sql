SELECT
    t."trip_id",
    t."duration_sec",
    TO_TIMESTAMP_NTZ(t."start_date" / 1e6) AS "start_date",
    t."start_station_name",
    CONCAT(t."start_station_name", ' - ', t."end_station_name") AS "route",
    t."bike_number",
    t."subscriber_type",
    t."member_birth_year",
    2017 - t."member_birth_year" AS "age",
    CASE
        WHEN (2017 - t."member_birth_year") < 40 THEN 'Young (<40 Y.O)'
        WHEN (2017 - t."member_birth_year" BETWEEN 40 AND 60) THEN 'Adult (40-60 Y.O)'
        ELSE 'Senior Adult (>60 Y.O)'
    END AS "age_class",
    t."member_gender",
    r."name" AS "region_name"
FROM
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_TRIPS" t
JOIN
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_STATION_INFO" s
    ON TO_VARCHAR(t."start_station_id") = s."station_id"
JOIN
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_BIKESHARE"."BIKESHARE_REGIONS" r
    ON s."region_id" = r."region_id"
WHERE
    TO_TIMESTAMP_NTZ(t."start_date" / 1e6) BETWEEN '2017-07-01' AND '2017-12-31'
    AND t."start_station_name" IS NOT NULL
    AND t."member_birth_year" IS NOT NULL
    AND t."member_gender" IS NOT NULL
ORDER BY
    t."duration_sec" DESC NULLS LAST
LIMIT 5;