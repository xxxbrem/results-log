WITH yearly_causes AS (
    SELECT
        EXTRACT(YEAR FROM TRY_TO_DATE("collision_date", 'YYYY-MM-DD')) AS "year",
        COALESCE(NULLIF("primary_collision_factor", ''), 'Unknown') AS "cause",
        COUNT(*) AS "cause_count"
    FROM
        CALIFORNIA_TRAFFIC_COLLISION.CALIFORNIA_TRAFFIC_COLLISION.COLLISIONS
    WHERE
        TRY_TO_DATE("collision_date", 'YYYY-MM-DD') IS NOT NULL
    GROUP BY
        "year", "cause"
),
yearly_top_causes AS (
    SELECT
        "year",
        "cause",
        "cause_count",
        DENSE_RANK() OVER (PARTITION BY "year" ORDER BY "cause_count" DESC NULLS LAST) AS "rank"
    FROM
        yearly_causes
),
top_two_causes_per_year AS (
    SELECT
        "year",
        "cause"
    FROM
        yearly_top_causes
    WHERE
        "rank" <= 2
),
pattern_per_year AS (
    SELECT
        "year",
        LISTAGG("cause", ',') WITHIN GROUP (ORDER BY "cause") AS "pattern"
    FROM
        top_two_causes_per_year
    GROUP BY
        "year"
),
pattern_counts AS (
    SELECT
        "pattern",
        COUNT(*) AS "pattern_count"
    FROM
        pattern_per_year
    GROUP BY
        "pattern"
)
SELECT
    p."year"
FROM
    pattern_per_year p
JOIN
    pattern_counts pc ON p."pattern" = pc."pattern"
WHERE
    pc."pattern_count" = 1
ORDER BY
    p."year";