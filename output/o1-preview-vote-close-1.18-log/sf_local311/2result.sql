WITH driver_totals AS (
    SELECT res."constructor_id", r."year", res."driver_id", SUM(res."points") AS "driver_points"
    FROM F1.F1."RESULTS" res
    JOIN F1.F1."RACES" r ON res."race_id" = r."race_id"
    GROUP BY res."constructor_id", r."year", res."driver_id"
),
best_driver_per_constructor_year AS (
    SELECT
        "constructor_id",
        "year",
        "driver_id",
        "driver_points",
        ROW_NUMBER() OVER (PARTITION BY "constructor_id", "year" ORDER BY "driver_points" DESC) AS rn
    FROM driver_totals
),
best_driver AS (
    SELECT "constructor_id", "year", "driver_id", "driver_points"
    FROM best_driver_per_constructor_year
    WHERE rn = 1
),
constructor_totals AS (
    SELECT cs."constructor_id", r."year", SUM(cs."points") AS "constructor_points"
    FROM F1.F1."CONSTRUCTOR_STANDINGS" cs
    JOIN F1.F1."RACES" r ON cs."race_id" = r."race_id"
    GROUP BY cs."constructor_id", r."year"
)
SELECT
    c."name" AS "Constructor_Name",
    bt."year" AS "Year",
    ROUND(bt."driver_points" + ct."constructor_points", 4) AS "Combined_Points"
FROM best_driver bt
JOIN constructor_totals ct ON bt."constructor_id" = ct."constructor_id" AND bt."year" = ct."year"
JOIN F1.F1."CONSTRUCTORS" c ON bt."constructor_id" = c."constructor_id"
ORDER BY "Combined_Points" DESC NULLS LAST
LIMIT 3;