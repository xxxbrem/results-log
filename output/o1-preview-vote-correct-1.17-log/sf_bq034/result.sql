SELECT "id", "name"
FROM GHCN_D.GHCN_D.GHCND_STATIONS
WHERE "latitude" IS NOT NULL AND "longitude" IS NOT NULL
  AND ST_DISTANCE(
        TO_GEOGRAPHY('POINT(' || ROUND("longitude", 4) || ' ' || ROUND("latitude", 4) || ')'),
        TO_GEOGRAPHY('POINT(-87.6847 41.8319)')
      ) <= 50000;