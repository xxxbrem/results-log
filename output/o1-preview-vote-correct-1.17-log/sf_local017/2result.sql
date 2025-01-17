WITH counted_causes AS (
    SELECT 
        SUBSTRING("collision_date", 1, 4) AS "year",
        "pcf_violation_category",
        COUNT(*) AS "collision_count"
    FROM "CALIFORNIA_TRAFFIC_COLLISION"."CALIFORNIA_TRAFFIC_COLLISION"."COLLISIONS"
    GROUP BY 
        SUBSTRING("collision_date", 1, 4),
        "pcf_violation_category"
),
ranked_causes AS (
    SELECT 
        "year",
        "pcf_violation_category",
        "collision_count",
        ROW_NUMBER() OVER (
            PARTITION BY "year"
            ORDER BY "collision_count" DESC NULLS LAST, "pcf_violation_category"
        ) AS rn
    FROM counted_causes
),
top_causes_per_year AS (
    SELECT 
        "year", 
        MAX(CASE WHEN rn = 1 THEN "pcf_violation_category" END) AS "top_cause1",
        MAX(CASE WHEN rn = 2 THEN "pcf_violation_category" END) AS "top_cause2"
    FROM ranked_causes
    WHERE rn <= 2
    GROUP BY "year"
),
cause_combinations AS (
    SELECT 
        "top_cause1", 
        "top_cause2", 
        COUNT(*) AS "year_count"
    FROM top_causes_per_year
    GROUP BY "top_cause1", "top_cause2"
)
SELECT t."year"
FROM top_causes_per_year t
JOIN cause_combinations c
    ON t."top_cause1" = c."top_cause1" AND t."top_cause2" = c."top_cause2"
WHERE c."year_count" = 1
ORDER BY t."year";