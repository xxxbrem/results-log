SELECT "major_category", SUM("value") AS "Number_of_incidents"
FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
WHERE "borough" = 'Barking and Dagenham'
GROUP BY "major_category"
ORDER BY SUM("value") DESC NULLS LAST
LIMIT 3;