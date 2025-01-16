WITH wyoming_counts AS (
    SELECT "name", SUM("number") AS total_in_wyoming
    FROM USA_NAMES.USA_NAMES.USA_1910_CURRENT
    WHERE "state" = 'WY' AND "gender" = 'F' AND "year" = 2021
    GROUP BY "name"
),
usa_counts AS (
    SELECT "name", SUM("number") AS total_in_usa
    FROM USA_NAMES.USA_NAMES.USA_1910_CURRENT
    WHERE "gender" = 'F' AND "year" = 2021
    GROUP BY "name"
)
SELECT wyoming_counts."name", ROUND(wyoming_counts.total_in_wyoming / usa_counts.total_in_usa, 4) AS "Proportion"
FROM wyoming_counts
JOIN usa_counts ON wyoming_counts."name" = usa_counts."name"
ORDER BY "Proportion" DESC NULLS LAST
LIMIT 1;