SELECT "major_category", CAST(SUM("value") AS DECIMAL(38,4)) AS "Number_of_Incidents"
FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
WHERE "borough" = 'Barking and Dagenham'
GROUP BY "major_category"
ORDER BY "Number_of_Incidents" DESC NULLS LAST
LIMIT 3;