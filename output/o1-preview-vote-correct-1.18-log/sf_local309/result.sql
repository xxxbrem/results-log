WITH driver_totals AS (
  SELECT D."driver_id", RA."year", D."full_name",
    SUM(R."points") AS "driver_points"
  FROM F1.F1."RESULTS" R
  JOIN F1.F1."RACES" RA ON R."race_id" = RA."race_id"
  JOIN F1.F1."DRIVERS" D ON R."driver_id" = D."driver_id"
  GROUP BY D."driver_id", D."full_name", RA."year"
),
driver_rankings AS (
  SELECT dt.*,
    RANK() OVER (PARTITION BY dt."year" ORDER BY dt."driver_points" DESC NULLS LAST) AS "driver_rank"
  FROM driver_totals dt
),
top_drivers AS (
  SELECT "driver_id", "year", "full_name", "driver_points"
  FROM driver_rankings
  WHERE "driver_rank" = 1
),
constructor_totals AS (
  SELECT C."constructor_id", RA."year", C."name",
    SUM(R."points") AS "constructor_points"
  FROM F1.F1."RESULTS" R
  JOIN F1.F1."RACES" RA ON R."race_id" = RA."race_id"
  JOIN F1.F1."CONSTRUCTORS" C ON R."constructor_id" = C."constructor_id"
  GROUP BY C."constructor_id", C."name", RA."year"
),
constructor_rankings AS (
  SELECT ct.*,
    RANK() OVER (PARTITION BY ct."year" ORDER BY ct."constructor_points" DESC NULLS LAST) AS "constructor_rank"
  FROM constructor_totals ct
),
top_constructors AS (
  SELECT "constructor_id", "year", "name", "constructor_points"
  FROM constructor_rankings
  WHERE "constructor_rank" = 1
)
SELECT td."year", td."full_name" AS "DriverName", tc."name" AS "ConstructorName"
FROM top_drivers td
JOIN top_constructors tc ON td."year" = tc."year"
ORDER BY td."year" ASC;