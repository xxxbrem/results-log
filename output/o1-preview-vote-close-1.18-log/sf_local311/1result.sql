WITH
constructor_points AS (
    SELECT cr."constructor_id", r."year", SUM(cr."points") AS "constructor_points"
    FROM "F1"."F1"."CONSTRUCTOR_RESULTS" cr
    JOIN "F1"."F1"."RACES" r ON cr."race_id" = r."race_id"
    GROUP BY cr."constructor_id", r."year"
),
driver_points AS (
    SELECT res."constructor_id", res."driver_id", r."year", SUM(res."points") AS "driver_points"
    FROM "F1"."F1"."RESULTS" res
    JOIN "F1"."F1"."RACES" r ON res."race_id" = r."race_id"
    GROUP BY res."constructor_id", res."driver_id", r."year"
),
best_driver_ranked AS (
    SELECT 
        dp."constructor_id", 
        dp."year", 
        dp."driver_id", 
        dp."driver_points",
        ROW_NUMBER() OVER (
            PARTITION BY dp."constructor_id", dp."year" 
            ORDER BY dp."driver_points" DESC NULLS LAST
        ) AS rn
    FROM driver_points dp
),
best_driver AS (
    SELECT bd."constructor_id", bd."year", bd."driver_id", bd."driver_points"
    FROM best_driver_ranked bd
    WHERE bd.rn = 1
),
combined_points AS (
    SELECT 
        cp."constructor_id", 
        cp."year", 
        (cp."constructor_points" + bd."driver_points") AS "Combined_Points"
    FROM constructor_points cp
    JOIN best_driver bd 
        ON cp."constructor_id" = bd."constructor_id" AND cp."year" = bd."year"
)
SELECT 
    c."name" AS "Constructor", 
    cp."year" AS "Year", 
    ROUND(cp."Combined_Points", 4) AS "Combined_Points"
FROM combined_points cp
JOIN "F1"."F1"."CONSTRUCTORS" c 
    ON cp."constructor_id" = c."constructor_id"
ORDER BY cp."Combined_Points" DESC NULLS LAST
LIMIT 3;