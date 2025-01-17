WITH category_counts AS (
    SELECT
        SUBSTRING("collision_date", 1, 4) AS "year",
        "pcf_violation_category",
        COUNT(*) AS "category_count"
    FROM
        CALIFORNIA_TRAFFIC_COLLISION.CALIFORNIA_TRAFFIC_COLLISION."COLLISIONS"
    WHERE
        "pcf_violation_category" IS NOT NULL AND "pcf_violation_category" <> ''
    GROUP BY
        SUBSTRING("collision_date", 1, 4),
        "pcf_violation_category"
),
top_two_categories AS (
    SELECT
        "year",
        "pcf_violation_category",
        ROW_NUMBER() OVER (
            PARTITION BY "year" 
            ORDER BY "category_count" DESC NULLS LAST
        ) AS "rank"
    FROM
        category_counts
),
year_top_categories AS (
    SELECT
        "year",
        LISTAGG("pcf_violation_category", ', ') WITHIN GROUP (ORDER BY "rank") AS "top_categories"
    FROM
        top_two_categories
    WHERE
        "rank" <= 2
    GROUP BY
        "year"
),
grouped_categories AS (
    SELECT
        "top_categories",
        COUNT(*) AS "num_years"
    FROM
        year_top_categories
    GROUP BY
        "top_categories"
)
SELECT
    CAST("year" AS INT) AS year
FROM
    year_top_categories yt
    JOIN grouped_categories gc ON yt."top_categories" = gc."top_categories"
WHERE
    gc."num_years" = 1
ORDER BY
    year;