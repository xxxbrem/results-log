WITH driver_points AS (
    SELECT
        r."year",
        res."driver_id",
        ROUND(SUM(res."points"), 4) AS "total_points"
    FROM
        F1.F1.RESULTS res
    JOIN
        F1.F1.RACES r ON res."race_id" = r."race_id"
    GROUP BY
        r."year",
        res."driver_id"
),
driver_ranked AS (
    SELECT
        dp.*,
        ROW_NUMBER() OVER (PARTITION BY dp."year" ORDER BY dp."total_points" DESC NULLS LAST) AS rn
    FROM
        driver_points dp
),
top_drivers AS (
    SELECT
        dr."year",
        dr."driver_id",
        dr."total_points"
    FROM
        driver_ranked dr
    WHERE dr.rn = 1
),
constructor_points AS (
    SELECT
        r."year",
        res."constructor_id",
        ROUND(SUM(res."points"), 4) AS "total_points"
    FROM
        F1.F1.RESULTS res
    JOIN
        F1.F1.RACES r ON res."race_id" = r."race_id"
    GROUP BY
        r."year",
        res."constructor_id"
),
constructor_ranked AS (
    SELECT
        cp.*,
        ROW_NUMBER() OVER (PARTITION BY cp."year" ORDER BY cp."total_points" DESC NULLS LAST) AS rn
    FROM
        constructor_points cp
),
top_constructors AS (
    SELECT
        cr."year",
        cr."constructor_id",
        cr."total_points"
    FROM
        constructor_ranked cr
    WHERE cr.rn = 1
),
combined AS (
    SELECT
        td."year",
        td."driver_id",
        td."total_points" AS "driver_points",
        tc."constructor_id",
        tc."total_points" AS "constructor_points"
    FROM
        top_drivers td
    JOIN
        top_constructors tc ON td."year" = tc."year"
)
SELECT
    c."year",
    d."full_name" AS "Driver_full_name",
    co."name" AS "Constructor_name"
FROM
    combined c
JOIN
    F1.F1.DRIVERS d ON c."driver_id" = d."driver_id"
JOIN
    F1.F1.CONSTRUCTORS co ON c."constructor_id" = co."constructor_id"
ORDER BY
    c."year" ASC;