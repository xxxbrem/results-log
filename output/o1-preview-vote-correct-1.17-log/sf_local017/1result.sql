WITH ranked_causes AS (
    SELECT
        SUBSTRING(c."collision_date", 1, 4) AS "Year",
        c."primary_collision_factor",
        COUNT(*) AS "Count",
        DENSE_RANK() OVER (
            PARTITION BY SUBSTRING(c."collision_date", 1, 4)
            ORDER BY COUNT(*) DESC NULLS LAST
        ) AS "Rank"
    FROM "CALIFORNIA_TRAFFIC_COLLISION"."CALIFORNIA_TRAFFIC_COLLISION"."COLLISIONS" c
    WHERE c."primary_collision_factor" IS NOT NULL
      AND c."primary_collision_factor" != ''
    GROUP BY SUBSTRING(c."collision_date", 1, 4), c."primary_collision_factor"
)
SELECT DISTINCT
    rc."Year" AS "year"
FROM ranked_causes rc
WHERE rc."Rank" = 2
  AND rc."primary_collision_factor" = 'other than driver'
ORDER BY rc."Year";