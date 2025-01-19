SELECT wy."name"
FROM
  (SELECT "name", "number"
   FROM "USA_NAMES"."USA_NAMES"."USA_1910_CURRENT"
   WHERE "state" = 'WY' AND "gender" = 'F' AND "year" = 2021) AS wy
JOIN
  (SELECT "name", SUM("number") AS "total_number"
   FROM "USA_NAMES"."USA_NAMES"."USA_1910_CURRENT"
   WHERE "gender" = 'F' AND "year" = 2021
   GROUP BY "name") AS nation
ON wy."name" = nation."name"
ORDER BY (wy."number" / nation."total_number") DESC NULLS LAST
LIMIT 1;