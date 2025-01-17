SELECT 
    DATE_FROM_PARTS(TO_NUMBER("year"), TO_NUMBER("mo"), TO_NUMBER("da")) AS date,
    ROUND(AVG("temp"), 4) AS avg_temp
FROM NOAA_GSOD.NOAA_GSOD.GSOD2009
WHERE "stn" = '723758' AND "year" = '2009' AND "mo" = '10'
GROUP BY "year", "mo", "da"
ORDER BY avg_temp DESC NULLS LAST
LIMIT 3;