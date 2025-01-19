WITH driver_totals AS (
    SELECT r."year", ds."driver_id", SUM(ds."points") AS total_driver_points
    FROM "F1"."F1"."DRIVER_STANDINGS" ds
    JOIN "F1"."F1"."RACES" r ON ds."race_id" = r."race_id"
    GROUP BY r."year", ds."driver_id"
),
driver_rank AS (
    SELECT dt.*, ROW_NUMBER() OVER (PARTITION BY dt."year" ORDER BY dt.total_driver_points DESC NULLS LAST) AS rn
    FROM driver_totals dt
),
top_driver_per_year AS (
    SELECT dr."year", dr."driver_id"
    FROM driver_rank dr
    WHERE dr.rn = 1
),
constructor_totals AS (
    SELECT r."year", cs."constructor_id", SUM(cs."points") AS total_constructor_points
    FROM "F1"."F1"."CONSTRUCTOR_STANDINGS" cs
    JOIN "F1"."F1"."RACES" r ON cs."race_id" = r."race_id"
    GROUP BY r."year", cs."constructor_id"
),
constructor_rank AS (
    SELECT ct.*, ROW_NUMBER() OVER (PARTITION BY ct."year" ORDER BY ct.total_constructor_points DESC NULLS LAST) AS rn
    FROM constructor_totals ct
),
top_constructor_per_year AS (
    SELECT cr."year", cr."constructor_id"
    FROM constructor_rank cr
    WHERE cr.rn = 1
)
SELECT tdp."year", d."full_name" AS "Driver_Name", c."name" AS "Constructor_Name"
FROM top_driver_per_year tdp
JOIN top_constructor_per_year tcp ON tdp."year" = tcp."year"
JOIN "F1"."F1"."DRIVERS" d ON tdp."driver_id" = d."driver_id"
JOIN "F1"."F1"."CONSTRUCTORS" c ON tcp."constructor_id" = c."constructor_id"
ORDER BY tdp."year" ASC;