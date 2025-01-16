SELECT wy_names."name", ROUND(wy_names."wyoming_name_count" / nat_names."national_name_count", 4) AS "proportion"
FROM
    (SELECT
        "name",
        SUM("number") AS "wyoming_name_count"
    FROM USA_NAMES.USA_NAMES.USA_1910_CURRENT
    WHERE "state" = 'WY' AND "gender" = 'F' AND "year" = 2021
    GROUP BY "name") AS wy_names
JOIN
    (SELECT
        "name",
        SUM("number") AS "national_name_count"
    FROM USA_NAMES.USA_NAMES.USA_1910_CURRENT
    WHERE "gender" = 'F' AND "year" = 2021
    GROUP BY "name") AS nat_names
ON wy_names."name" = nat_names."name"
ORDER BY "proportion" DESC NULLS LAST
LIMIT 1;