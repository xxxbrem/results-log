SELECT wy_names."name" AS "Name"
FROM 
  (SELECT "name", SUM("number") AS wy_number
   FROM USA_NAMES.USA_NAMES.USA_1910_CURRENT
   WHERE "state" = 'WY' AND "gender" = 'F' AND "year" = 2021
   GROUP BY "name") AS wy_names
JOIN
  (SELECT "name", SUM("number") AS total_number
   FROM USA_NAMES.USA_NAMES.USA_1910_CURRENT
   WHERE "gender" = 'F' AND "year" = 2021
   GROUP BY "name") AS usa_names
ON wy_names."name" = usa_names."name"
ORDER BY (wy_names.wy_number / usa_names.total_number) DESC NULLS LAST
LIMIT 1;