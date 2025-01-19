WITH driver_points AS (
    SELECT
        r."year",
        d."driver_id",
        d."full_name",
        SUM(res."points") AS "total_points"
    FROM "results" res
    JOIN "races" r ON res."race_id" = r."race_id"
    JOIN "drivers" d ON res."driver_id" = d."driver_id"
    GROUP BY r."year", d."driver_id", d."full_name"
),
max_driver_points AS (
    SELECT
        "year",
        MAX("total_points") AS "max_points"
    FROM driver_points
    GROUP BY "year"
),
top_drivers AS (
    SELECT dp."year", dp."full_name" AS "Driver Full Name"
    FROM driver_points dp
    JOIN max_driver_points mdp ON dp."year" = mdp."year" AND dp."total_points" = mdp."max_points"
),
constructor_points AS (
    SELECT
        r."year",
        c."constructor_id",
        c."name" AS "Constructor Name",
        SUM(res."points") AS "total_points"
    FROM "results" res
    JOIN "races" r ON res."race_id" = r."race_id"
    JOIN "constructors" c ON res."constructor_id" = c."constructor_id"
    GROUP BY r."year", c."constructor_id", c."name"
),
max_constructor_points AS (
    SELECT
        "year",
        MAX("total_points") AS "max_points"
    FROM constructor_points
    GROUP BY "year"
),
top_constructors AS (
    SELECT cp."year", cp."Constructor Name"
    FROM constructor_points cp
    JOIN max_constructor_points mcp ON cp."year" = mcp."year" AND cp."total_points" = mcp."max_points"
)
SELECT
    td."year" AS "Year",
    td."Driver Full Name",
    tc."Constructor Name"
FROM top_drivers td
JOIN top_constructors tc ON td."year" = tc."year"
ORDER BY td."year";