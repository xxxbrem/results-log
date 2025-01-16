SELECT
  "year",
  ROUND((SUM(CASE WHEN "minor_category" = 'Other Theft' THEN "value" ELSE 0 END) * 100.0) / SUM("value"), 2) AS "Other Theft (%)",
  ROUND((SUM(CASE WHEN "minor_category" = 'Theft From Motor Vehicle' THEN "value" ELSE 0 END) * 100.0) / SUM("value"), 2) AS "Theft From Motor Vehicle (%)",
  ROUND((SUM(CASE WHEN "minor_category" = 'Possession Of Drugs' THEN "value" ELSE 0 END) * 100.0) / SUM("value"), 2) AS "Possession Of Drugs (%)",
  ROUND((SUM(CASE WHEN "minor_category" = 'Burglary in a Dwelling' THEN "value" ELSE 0 END) * 100.0) / SUM("value"), 2) AS "Burglary in a Dwelling (%)",
  ROUND((SUM(CASE WHEN "minor_category" = 'Assault with Injury' THEN "value" ELSE 0 END) * 100.0) / SUM("value"), 2) AS "Assault with Injury (%)"
FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
GROUP BY "year"
ORDER BY "year";