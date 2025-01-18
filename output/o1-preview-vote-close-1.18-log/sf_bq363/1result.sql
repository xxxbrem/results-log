SELECT Quantile AS Trip_duration_quantile,
       COUNT(*) AS Total_number_of_trips,
       ROUND(AVG("fare"), 4) AS Average_fare
FROM (
  SELECT "fare",
         NTILE(10) OVER (ORDER BY ROUND("trip_seconds" / 60.0)) AS Quantile
  FROM CHICAGO.CHICAGO_TAXI_TRIPS.TAXI_TRIPS
  WHERE ROUND("trip_seconds" / 60.0) BETWEEN 1 AND 50
    AND "trip_seconds" IS NOT NULL
    AND "fare" IS NOT NULL
    AND "fare" >= 0
) sub
GROUP BY Quantile
ORDER BY Quantile;