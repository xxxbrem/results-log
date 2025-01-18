SELECT c."name" AS "Constructor Name", result."year", ROUND(result."combined_points", 4) AS "Combined Points"
FROM (
    SELECT cp."constructor_id", cp."year", cp."constructor_points", bd."best_driver_points", 
           (cp."constructor_points" + bd."best_driver_points") AS "combined_points"
    FROM
        (SELECT cr."constructor_id", r."year", SUM(cr."points") AS "constructor_points"
         FROM F1.F1."CONSTRUCTOR_RESULTS" cr
         JOIN F1.F1."RACES" r ON cr."race_id" = r."race_id"
         GROUP BY cr."constructor_id", r."year") cp
    JOIN
        (SELECT "constructor_id", "year", MAX("driver_points") AS "best_driver_points"
         FROM (
             SELECT dr."driver_id", dr."constructor_id", r."year", SUM(dr."points") AS "driver_points"
             FROM F1.F1."RESULTS" dr
             JOIN F1.F1."RACES" r ON dr."race_id" = r."race_id"
             GROUP BY dr."driver_id", dr."constructor_id", r."year"
         ) AS driver_totals
         GROUP BY "constructor_id", "year") bd
    ON cp."constructor_id" = bd."constructor_id" AND cp."year" = bd."year"
) result
JOIN F1.F1."CONSTRUCTORS" c ON result."constructor_id" = c."constructor_id"
ORDER BY result."combined_points" DESC NULLS LAST
LIMIT 3;