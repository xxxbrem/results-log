WITH driver_totals AS (
    SELECT ds."driver_id", r."year", SUM(ds."points") AS "total_points"
    FROM F1.F1."DRIVER_STANDINGS" ds
    JOIN F1.F1."RACES" r ON ds."race_id" = r."race_id"
    GROUP BY ds."driver_id", r."year"
),
top_drivers AS (
    SELECT dt."year", dt."driver_id", dt."total_points"
    FROM driver_totals dt
    WHERE dt."total_points" = (
        SELECT MAX(dt2."total_points")
        FROM driver_totals dt2
        WHERE dt2."year" = dt."year"
    )
),
constructor_totals AS (
    SELECT cs."constructor_id", r."year", SUM(cs."points") AS "total_points"
    FROM F1.F1."CONSTRUCTOR_STANDINGS" cs
    JOIN F1.F1."RACES" r ON cs."race_id" = r."race_id"
    GROUP BY cs."constructor_id", r."year"
),
top_constructors AS (
    SELECT ct."year", ct."constructor_id", ct."total_points"
    FROM constructor_totals ct
    WHERE ct."total_points" = (
        SELECT MAX(ct2."total_points")
        FROM constructor_totals ct2
        WHERE ct2."year" = ct."year"
    )
)
SELECT td."year", d."full_name" AS "driver_full_name", c."name" AS "constructor_name", ROUND(td."total_points", 4) AS "points"
FROM top_drivers td
JOIN F1.F1."DRIVERS" d ON td."driver_id" = d."driver_id"
JOIN top_constructors tc ON td."year" = tc."year"
JOIN F1.F1."CONSTRUCTORS" c ON tc."constructor_id" = c."constructor_id"
ORDER BY td."year";