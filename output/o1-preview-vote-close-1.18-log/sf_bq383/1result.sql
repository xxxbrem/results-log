SELECT
    "Year",
    ROUND(MAX("Highest Precipitation (mm)"), 4) AS "Highest Precipitation (mm)",
    ROUND(MIN("Minimum Temperature (°C)"), 4) AS "Minimum Temperature (°C)",
    ROUND(MAX("Maximum Temperature (°C)"), 4) AS "Maximum Temperature (°C)"
FROM
(
    SELECT
        EXTRACT(YEAR FROM "date") AS "Year",
        CASE WHEN "element" = 'PRCP' THEN "value" / 10.0 END AS "Highest Precipitation (mm)",
        CASE WHEN "element" = 'TMIN' THEN "value" / 10.0 END AS "Minimum Temperature (°C)",
        CASE WHEN "element" = 'TMAX' THEN "value" / 10.0 END AS "Maximum Temperature (°C)"
    FROM
    (
        SELECT "id", "date", "element", "value", "mflag", "qflag", "sflag", "time" FROM GHCN_D.GHCN_D.GHCND_2013
        UNION ALL
        SELECT "id", "date", "element", "value", "mflag", "qflag", "sflag", "time" FROM GHCN_D.GHCN_D.GHCND_2014
        UNION ALL
        SELECT "id", "date", "element", "value", "mflag", "qflag", "sflag", "time" FROM GHCN_D.GHCN_D.GHCND_2015
        UNION ALL
        SELECT "id", "date", "element", "value", "mflag", "qflag", "sflag", "time" FROM GHCN_D.GHCN_D.GHCND_2016
    ) AS all_data
    WHERE
        "id" = 'USW00094846' AND
        (
            ("date" BETWEEN DATE '2013-12-17' AND DATE '2013-12-31') OR
            ("date" BETWEEN DATE '2014-12-17' AND DATE '2014-12-31') OR
            ("date" BETWEEN DATE '2015-12-17' AND DATE '2015-12-31') OR
            ("date" BETWEEN DATE '2016-12-17' AND DATE '2016-12-31')
        ) AND
        "element" IN ('PRCP', 'TMIN', 'TMAX') AND
        "qflag" IS NULL
) AS sub
GROUP BY "Year"
ORDER BY "Year";