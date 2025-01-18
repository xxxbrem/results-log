SELECT
    EXTRACT(YEAR FROM "date") AS "Year",
    MAX(CASE WHEN "element" = 'PRCP' THEN ROUND("value"/10.0, 4) END) AS "Highest Precipitation (mm)",
    MIN(CASE WHEN "element" = 'TMIN' THEN ROUND("value"/10.0, 4) END) AS "Lowest Minimum Temperature (°C)",
    MAX(CASE WHEN "element" = 'TMAX' THEN ROUND("value"/10.0, 4) END) AS "Highest Maximum Temperature (°C)"
FROM
    (
        SELECT "id", "date", "element", "value", "qflag"
        FROM GHCN_D.GHCN_D.GHCND_2013
        UNION ALL
        SELECT "id", "date", "element", "value", "qflag"
        FROM GHCN_D.GHCN_D.GHCND_2014
        UNION ALL
        SELECT "id", "date", "element", "value", "qflag"
        FROM GHCN_D.GHCN_D.GHCND_2015
        UNION ALL
        SELECT "id", "date", "element", "value", "qflag"
        FROM GHCN_D.GHCN_D.GHCND_2016
    ) AS data
WHERE
    "id" = 'USW00094846' AND
    EXTRACT(YEAR FROM "date") BETWEEN 2013 AND 2016 AND
    EXTRACT(MONTH FROM "date") = 12 AND
    EXTRACT(DAY FROM "date") BETWEEN 17 AND 31 AND
    "element" IN ('PRCP', 'TMIN', 'TMAX') AND
    "qflag" IS NULL
GROUP BY
    "Year"
ORDER BY
    "Year";