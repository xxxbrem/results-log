SELECT
    EXTRACT(YEAR FROM "date") AS "Year",
    ROUND(MAX(CASE WHEN "element" = 'PRCP' THEN "value" / 10.0 END), 4) AS "Highest Precipitation (mm)",
    ROUND(MIN(CASE WHEN "element" = 'TMIN' THEN "value" / 10.0 END), 4) AS "Minimum Temperature (°C)",
    ROUND(MAX(CASE WHEN "element" = 'TMAX' THEN "value" / 10.0 END), 4) AS "Maximum Temperature (°C)"
FROM (
    SELECT "id", "date", "element", "value", "qflag"
    FROM GHCN_D.GHCN_D."GHCND_2013"
    UNION ALL
    SELECT "id", "date", "element", "value", "qflag"
    FROM GHCN_D.GHCN_D."GHCND_2014"
    UNION ALL
    SELECT "id", "date", "element", "value", "qflag"
    FROM GHCN_D.GHCN_D."GHCND_2015"
    UNION ALL
    SELECT "id", "date", "element", "value", "qflag"
    FROM GHCN_D.GHCN_D."GHCND_2016"
) AS CombinedData
WHERE "id" = 'USW00094846'
  AND "element" IN ('PRCP', 'TMIN', 'TMAX')
  AND "qflag" IS NULL
  AND EXTRACT(MONTH FROM "date") = 12
  AND EXTRACT(DAY FROM "date") BETWEEN 17 AND 31
GROUP BY EXTRACT(YEAR FROM "date")
ORDER BY "Year";