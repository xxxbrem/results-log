WITH driver_points AS (
    SELECT
        ra."year",
        r."driver_id",
        SUM(r."points") AS "total_points"
    FROM
        F1.F1.RESULTS r
        JOIN F1.F1.RACES ra ON ra."race_id" = r."race_id"
    GROUP BY
        ra."year",
        r."driver_id"
),
max_driver_points AS (
    SELECT
        dp."year",
        dp."driver_id",
        dp."total_points",
        RANK() OVER (PARTITION BY dp."year" ORDER BY dp."total_points" DESC NULLS LAST) AS "rank"
    FROM
        driver_points dp
),
top_driver_per_year AS (
    SELECT
        mdp."year",
        mdp."driver_id",
        mdp."total_points"
    FROM
        max_driver_points mdp
    WHERE
        mdp."rank" = 1
),
driver_names AS (
    SELECT
        d."driver_id",
        d."full_name"
    FROM
        F1.F1.DRIVERS d
),
driver_result AS (
    SELECT
        tdp."year",
        dn."full_name" AS "driver_full_name"
    FROM
        top_driver_per_year tdp
        JOIN driver_names dn ON dn."driver_id" = tdp."driver_id"
),
constructor_points AS (
    SELECT
        ra."year",
        r."constructor_id",
        SUM(r."points") AS "total_points"
    FROM
        F1.F1.RESULTS r
        JOIN F1.F1.RACES ra ON ra."race_id" = r."race_id"
    GROUP BY
        ra."year",
        r."constructor_id"
),
max_constructor_points AS (
    SELECT
        cp."year",
        cp."constructor_id",
        cp."total_points",
        RANK() OVER (PARTITION BY cp."year" ORDER BY cp."total_points" DESC NULLS LAST) AS "rank"
    FROM
        constructor_points cp
),
top_constructor_per_year AS (
    SELECT
        mcp."year",
        mcp."constructor_id",
        mcp."total_points"
    FROM
        max_constructor_points mcp
    WHERE
        mcp."rank" = 1
),
constructor_names AS (
    SELECT
        c."constructor_id",
        c."name" AS "constructor_name"
    FROM
        F1.F1.CONSTRUCTORS c
),
constructor_result AS (
    SELECT
        tcp."year",
        cn."constructor_name"
    FROM
        top_constructor_per_year tcp
        JOIN constructor_names cn ON cn."constructor_id" = tcp."constructor_id"
)
SELECT
    dr."year",
    dr."driver_full_name",
    cr."constructor_name"
FROM
    driver_result dr
    JOIN constructor_result cr ON cr."year" = dr."year"
ORDER BY
    dr."year";