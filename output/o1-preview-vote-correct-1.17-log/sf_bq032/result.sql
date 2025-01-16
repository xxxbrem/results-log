SELECT ROUND(h_final."latitude", 4) AS "latitude"
FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES h_final
WHERE h_final."sid" = (
    SELECT t."sid"
    FROM (
        SELECT h."sid",
               SUM(h."segment_distance") AS "total_distance"
        FROM (
            SELECT h1."sid",
                   h1."iso_time",
                   ST_DISTANCE(
                       ST_POINT(h1."longitude", h1."latitude"),
                       ST_POINT(
                           LAG(h1."longitude") OVER (PARTITION BY h1."sid" ORDER BY h1."iso_time"),
                           LAG(h1."latitude") OVER (PARTITION BY h1."sid" ORDER BY h1."iso_time")
                       )
                   ) AS "segment_distance"
            FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES h1
            WHERE h1."season" = '2020' AND h1."basin" = 'NA'
        ) h
        WHERE h."segment_distance" IS NOT NULL
        GROUP BY h."sid"
        ORDER BY "total_distance" DESC NULLS LAST
        LIMIT 2
    ) t
    ORDER BY t."total_distance" DESC NULLS LAST
    LIMIT 1 OFFSET 1
)
AND h_final."iso_time" = (
    SELECT MAX(h2."iso_time")
    FROM NOAA_DATA.NOAA_HURRICANES.HURRICANES h2
    WHERE h2."sid" = h_final."sid"
);