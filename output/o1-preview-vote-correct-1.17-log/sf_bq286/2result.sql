SELECT wy."name",
       ROUND((wy."number"::FLOAT / total_name."total"), 4) AS "proportion"
FROM (
    SELECT "name", SUM("number") AS "number"
    FROM USA_NAMES.USA_NAMES.USA_1910_CURRENT
    WHERE "state" = 'WY' AND "gender" = 'F' AND "year" = 2021
    GROUP BY "name"
) AS wy
JOIN (
    SELECT "name", SUM("number") AS "total"
    FROM USA_NAMES.USA_NAMES.USA_1910_CURRENT
    WHERE "gender" = 'F' AND "year" = 2021
    GROUP BY "name"
) AS total_name
ON wy."name" = total_name."name"
ORDER BY "proportion" DESC NULLS LAST
LIMIT 1;