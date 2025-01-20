WITH cause_counts AS (
    SELECT
        ci."db_year" AS "Year",
        c."pcf_violation_category",
        COUNT(*) AS "cause_count"
    FROM
        "CALIFORNIA_TRAFFIC_COLLISION"."CALIFORNIA_TRAFFIC_COLLISION"."COLLISIONS" c
    JOIN
        "CALIFORNIA_TRAFFIC_COLLISION"."CALIFORNIA_TRAFFIC_COLLISION"."CASE_IDS" ci
        ON c."case_id" = ci."case_id"
    WHERE
        c."pcf_violation_category" IS NOT NULL AND ci."db_year" IS NOT NULL
    GROUP BY
        ci."db_year",
        c."pcf_violation_category"
),
ranked_causes AS (
    SELECT
        cc."Year",
        cc."pcf_violation_category",
        cc."cause_count",
        ROW_NUMBER() OVER (
            PARTITION BY cc."Year" ORDER BY cc."cause_count" DESC
        ) AS "rank"
    FROM
        cause_counts cc
),
top_two_causes AS (
    SELECT
        rc."Year",
        LISTAGG(rc."pcf_violation_category", ',') WITHIN GROUP (ORDER BY rc."pcf_violation_category") AS "top_two_causes"
    FROM
        ranked_causes rc
    WHERE
        rc."rank" <= 2
    GROUP BY
        rc."Year"
),
cause_group_counts AS (
    SELECT
        "top_two_causes",
        COUNT(*) AS "years_count"
    FROM
        top_two_causes
    GROUP BY
        "top_two_causes"
)
SELECT
    ttc."Year" AS "Year"
FROM
    top_two_causes ttc
JOIN
    cause_group_counts cgc
    ON ttc."top_two_causes" = cgc."top_two_causes"
WHERE
    cgc."years_count" = 1;