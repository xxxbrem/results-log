WITH driver_points AS (
  SELECT
    R."year",
    RE."driver_id",
    SUM(RE."points") AS "driver_points"
  FROM F1.F1.RESULTS RE
  JOIN F1.F1.RACES R ON RE."race_id" = R."race_id"
  GROUP BY R."year", RE."driver_id"
),
top_driver_per_year AS (
  SELECT
    D."year",
    D."driver_id",
    D."driver_points",
    ROW_NUMBER() OVER (PARTITION BY D."year" ORDER BY D."driver_points" DESC NULLS LAST) AS "rn"
  FROM driver_points D
),
max_driver AS (
  SELECT
    TD."year",
    TD."driver_id",
    TD."driver_points"
  FROM top_driver_per_year TD
  WHERE TD."rn" = 1
),
constructor_points AS (
  SELECT
    R."year",
    RE."constructor_id",
    SUM(RE."points") AS "constructor_points"
  FROM F1.F1.RESULTS RE
  JOIN F1.F1.RACES R ON RE."race_id" = R."race_id"
  GROUP BY R."year", RE."constructor_id"
),
top_constructor_per_year AS (
  SELECT
    C."year",
    C."constructor_id",
    C."constructor_points",
    ROW_NUMBER() OVER (PARTITION BY C."year" ORDER BY C."constructor_points" DESC NULLS LAST) AS "rn"
  FROM constructor_points C
),
max_constructor AS (
  SELECT
    TC."year",
    TC."constructor_id",
    TC."constructor_points"
  FROM top_constructor_per_year TC
  WHERE TC."rn" = 1
)
SELECT
  MD."year",
  D."full_name" AS "driver_full_name",
  ROUND(MD."driver_points", 4) AS "driver_points",
  C."name" AS "constructor_name",
  ROUND(MC."constructor_points", 4) AS "constructor_points"
FROM max_driver MD
JOIN F1.F1.DRIVERS D ON MD."driver_id" = D."driver_id"
JOIN max_constructor MC ON MD."year" = MC."year"
JOIN F1.F1.CONSTRUCTORS C ON MC."constructor_id" = C."constructor_id"
ORDER BY MD."year" NULLS LAST;