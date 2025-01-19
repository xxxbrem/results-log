SELECT "id", "name"
FROM GHCN_D.GHCN_D.GHCND_STATIONS
WHERE (
    6371 * 2 * ASIN(SQRT(
        POWER(SIN((RADIANS("latitude") - RADIANS(41.8319)) / 2), 2) +
        COS(RADIANS(41.8319)) * COS(RADIANS("latitude")) *
        POWER(SIN((RADIANS("longitude") - RADIANS(-87.6847)) / 2), 2)
    ))
) <= 50;