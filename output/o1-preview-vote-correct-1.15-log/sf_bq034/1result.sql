SELECT "id", "name"
FROM GHCN_D.GHCN_D.GHCND_STATIONS
WHERE ST_DISTANCE(
    TO_GEOGRAPHY(ST_MAKEPOINT("longitude", "latitude")),
    TO_GEOGRAPHY(ST_MAKEPOINT(-87.6847, 41.8319))
) <= 50000;