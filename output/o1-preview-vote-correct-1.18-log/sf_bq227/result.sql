WITH total_crimes_per_year AS (
  SELECT "year", SUM("value") AS "total_crimes"
  FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
  GROUP BY "year"
),
crimes_per_year_minor AS (
  SELECT "year", "minor_category", SUM("value") AS "minor_crime_total"
  FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
  WHERE "minor_category" IN (
    'Other Theft', 
    'Theft From Motor Vehicle', 
    'Possession Of Drugs', 
    'Burglary in a Dwelling', 
    'Assault with Injury'
  )
  GROUP BY "year", "minor_category"
),
combined AS (
  SELECT 
    c."year", 
    c."minor_category", 
    c."minor_crime_total", 
    t."total_crimes",
    ROUND((c."minor_crime_total" / t."total_crimes") * 100, 4) AS "percentage"
  FROM crimes_per_year_minor c
  JOIN total_crimes_per_year t ON c."year" = t."year"
)
SELECT 
  "year",
  ROUND(MAX(CASE WHEN "minor_category" = 'Other Theft' THEN "percentage" END), 2) AS "Other Theft",
  ROUND(MAX(CASE WHEN "minor_category" = 'Theft From Motor Vehicle' THEN "percentage" END), 2) AS "Theft From Motor Vehicle",
  ROUND(MAX(CASE WHEN "minor_category" = 'Possession Of Drugs' THEN "percentage" END), 2) AS "Possession Of Drugs",
  ROUND(MAX(CASE WHEN "minor_category" = 'Burglary in a Dwelling' THEN "percentage" END), 2) AS "Burglary in a Dwelling",
  ROUND(MAX(CASE WHEN "minor_category" = 'Assault with Injury' THEN "percentage" END), 2) AS "Assault with Injury"
FROM combined
GROUP BY "year"
ORDER BY "year";