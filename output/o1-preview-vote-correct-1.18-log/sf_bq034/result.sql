SELECT "id", "name"
FROM GHCN_D.GHCN_D.GHCND_STATIONS
WHERE
    "latitude" IS NOT NULL AND
    "longitude" IS NOT NULL AND
    (
        2.0000 * 6371.0000 * ASIN(
            SQRT(
                POWER(SIN(RADIANS(("latitude" - 41.8319) / 2.0000)), 2.0000) +
                COS(RADIANS(41.8319)) * COS(RADIANS("latitude")) *
                POWER(SIN(RADIANS(("longitude" - (-87.6847)) / 2.0000)), 2.0000)
            )
        )
    ) <= 50.0000;