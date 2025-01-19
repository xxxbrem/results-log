SELECT
    "id",
    "name"
FROM
    GHCN_D.GHCN_D.GHCND_STATIONS
WHERE
    (
        6371 * 2 * ATAN2(
            SQRT(
                SIN(RADIANS(("latitude" - 41.8319) / 2)) * SIN(RADIANS(("latitude" - 41.8319) / 2)) +
                COS(RADIANS(41.8319)) * COS(RADIANS("latitude")) * SIN(RADIANS(("longitude" - (-87.6847)) / 2)) * SIN(RADIANS(("longitude" - (-87.6847)) / 2))
            ),
            SQRT(
                1 - (
                    SIN(RADIANS(("latitude" - 41.8319) / 2)) * SIN(RADIANS(("latitude" - 41.8319) / 2)) +
                    COS(RADIANS(41.8319)) * COS(RADIANS("latitude")) * SIN(RADIANS(("longitude" - (-87.6847)) / 2)) * SIN(RADIANS(("longitude" - (-87.6847)) / 2))
                )
            )
        )
    ) <= 50;