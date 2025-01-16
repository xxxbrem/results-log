SELECT "id" AS "station_id", "name" AS "station_name"
FROM "GHCN_D"."GHCN_D"."GHCND_STATIONS"
WHERE ST_DISTANCE(
    ST_GEOGFROMTEXT('POINT(' || "longitude" || ' ' || "latitude" || ')'),
    ST_GEOGFROMTEXT('POINT(-87.6847 41.8319)')
) <= 50000;