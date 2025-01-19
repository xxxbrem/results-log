SELECT wy."name"
FROM (
    SELECT "name", "number" AS wy_number
    FROM "USA_NAMES"."USA_NAMES"."USA_1910_CURRENT"
    WHERE "state" = 'WY' AND "gender" = 'F' AND "year" = 2021
) wy
JOIN (
    SELECT "name", SUM("number") AS total_usa_number
    FROM "USA_NAMES"."USA_NAMES"."USA_1910_CURRENT"
    WHERE "gender" = 'F' AND "year" = 2021
    GROUP BY "name"
) usa ON wy."name" = usa."name"
ORDER BY wy_number / total_usa_number DESC NULLS LAST
LIMIT 1;