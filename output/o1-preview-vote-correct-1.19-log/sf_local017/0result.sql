WITH
year_causes AS (
    SELECT
        SUBSTRING("collision_date", 1, 4) AS "year",
        "pcf_violation_category",
        COUNT(*) AS "count"
    FROM CALIFORNIA_TRAFFIC_COLLISION.CALIFORNIA_TRAFFIC_COLLISION.COLLISIONS
    GROUP BY "year", "pcf_violation_category"
),
ranked_causes AS (
    SELECT
        "year",
        "pcf_violation_category",
        "count",
        RANK() OVER (PARTITION BY "year" ORDER BY "count" DESC NULLS LAST) AS "cause_rank"
    FROM year_causes
),
top_causes AS (
    SELECT
        "year",
        "pcf_violation_category"
    FROM ranked_causes
    WHERE "cause_rank" <= 2
),
year_top_causes AS (
    SELECT
        "year",
        LISTAGG("pcf_violation_category", ',') WITHIN GROUP (ORDER BY "pcf_violation_category") AS "top_two_causes"
    FROM top_causes
    GROUP BY "year"
),
cause_occurrences AS (
    SELECT
        "top_two_causes",
        COUNT(*) AS "year_count"
    FROM year_top_causes
    GROUP BY "top_two_causes"
),
unique_causes AS (
    SELECT "top_two_causes"
    FROM cause_occurrences
    WHERE "year_count" = 1
)
SELECT CAST("year" AS INT) AS "year"
FROM year_top_causes
WHERE "top_two_causes" IN (SELECT "top_two_causes" FROM unique_causes)
ORDER BY CAST("year" AS INT);