SELECT
    TO_CHAR(t1."departure_time", 'HH24:MI:SS') AS "Start_time",
    TO_CHAR(t2."arrival_time", 'HH24:MI:SS') AS "End_time",
    tr."trip_headsign" AS "Trip_Headsign"
FROM
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_TRANSIT_MUNI"."STOP_TIMES" t1
JOIN
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_TRANSIT_MUNI"."STOP_TIMES" t2
    ON t1."trip_id" = t2."trip_id"
JOIN
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_TRANSIT_MUNI"."TRIPS" tr
    ON t1."trip_id" = tr."trip_id"
WHERE
    t1."stop_id" = 14015 AND
    t2."stop_id" = 16294 AND
    t1."stop_sequence" < t2."stop_sequence"
ORDER BY
    t1."departure_time";