WITH
collisions_with_year AS (
    SELECT
        EXTRACT(YEAR FROM TO_DATE("collision_date", 'YYYY-MM-DD')) AS "year",
        "primary_collision_factor"
    FROM
        "CALIFORNIA_TRAFFIC_COLLISION"."CALIFORNIA_TRAFFIC_COLLISION"."COLLISIONS"
    WHERE
        "primary_collision_factor" IS NOT NULL
        AND "primary_collision_factor" <> ''
),
cause_counts AS (
    SELECT
        "year",
        "primary_collision_factor",
        COUNT(*) AS cnt
    FROM
        collisions_with_year
    GROUP BY
        "year",
        "primary_collision_factor"
),
top_causes_per_year AS (
    SELECT
        "year",
        "primary_collision_factor",
        cnt,
        ROW_NUMBER() OVER (
            PARTITION BY "year"
            ORDER BY cnt DESC NULLS LAST
        ) AS rn
    FROM
        cause_counts
),
year_causes AS (
    SELECT
        "year",
        LISTAGG("primary_collision_factor", ',') WITHIN GROUP (ORDER BY "primary_collision_factor") AS "year_causes"
    FROM
        top_causes_per_year
    WHERE
        rn <= 2
    GROUP BY
        "year"
),
cause_counts_excl_year AS (
    SELECT
        y."year",
        c."primary_collision_factor",
        SUM(c.cnt) AS cnt
    FROM
        (SELECT DISTINCT "year" FROM collisions_with_year) y
    JOIN
        cause_counts c
        ON c."year" <> y."year"
    GROUP BY
        y."year",
        c."primary_collision_factor"
),
top_causes_excl_year AS (
    SELECT
        "year",
        "primary_collision_factor",
        cnt,
        ROW_NUMBER() OVER (
            PARTITION BY "year"
            ORDER BY cnt DESC NULLS LAST
        ) AS rn
    FROM
        cause_counts_excl_year
),
other_years_causes AS (
    SELECT
        "year",
        LISTAGG("primary_collision_factor", ',') WITHIN GROUP (ORDER BY "primary_collision_factor") AS "other_years_causes"
    FROM
        top_causes_excl_year
    WHERE
        rn <= 2
    GROUP BY
        "year"
),
comparison AS (
    SELECT
        yc."year",
        yc."year_causes",
        oyc."other_years_causes"
    FROM
        year_causes yc
    JOIN
        other_years_causes oyc
            ON yc."year" = oyc."year"
)
SELECT
    "year" AS "Year"
FROM
    comparison
WHERE
    "year_causes" <> "other_years_causes"
ORDER BY
    "Year";