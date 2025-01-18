SELECT 
    st_start."departure_time" AS "start_time",
    st_end."arrival_time" AS "end_time",
    t."trip_headsign"
FROM 
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_TRANSIT_MUNI"."STOP_TIMES" st_start
JOIN 
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_TRANSIT_MUNI"."STOP_TIMES" st_end
    ON st_start."trip_id" = st_end."trip_id"
JOIN 
    "SAN_FRANCISCO_PLUS"."SAN_FRANCISCO_TRANSIT_MUNI"."TRIPS" t
    ON st_start."trip_id" = t."trip_id"
WHERE 
    st_start."stop_id" = 14015
    AND st_end."stop_id" = 16294
    AND st_start."stop_sequence" < st_end."stop_sequence"
ORDER BY 
    st_start."departure_time"