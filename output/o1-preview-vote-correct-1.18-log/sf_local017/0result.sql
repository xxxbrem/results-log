WITH CauseCounts AS (
    SELECT ci."db_year", c."pcf_violation_category", COUNT(*) AS "collision_count"
    FROM "CALIFORNIA_TRAFFIC_COLLISION"."CALIFORNIA_TRAFFIC_COLLISION"."COLLISIONS" c
    INNER JOIN "CALIFORNIA_TRAFFIC_COLLISION"."CALIFORNIA_TRAFFIC_COLLISION"."CASE_IDS" ci
        ON c."case_id" = ci."case_id"
    WHERE c."pcf_violation_category" IS NOT NULL AND c."pcf_violation_category" <> ''
    GROUP BY ci."db_year", c."pcf_violation_category"
),
RankedCauses AS (
    SELECT "db_year", "pcf_violation_category", "collision_count",
           DENSE_RANK() OVER (
               PARTITION BY "db_year" 
               ORDER BY "collision_count" DESC NULLS LAST
           ) AS "cause_rank"
    FROM CauseCounts
),
TopCauses AS (
    SELECT "db_year", "pcf_violation_category"
    FROM RankedCauses
    WHERE "cause_rank" <= 2
),
YearTopCauses AS (
    SELECT "db_year",
           LISTAGG("pcf_violation_category", '|') WITHIN GROUP (ORDER BY "pcf_violation_category") AS "top_causes"
    FROM TopCauses
    GROUP BY "db_year"
),
CausesOccurrence AS (
    SELECT "top_causes", COUNT(*) AS "years_count"
    FROM YearTopCauses
    GROUP BY "top_causes"
),
UniqueCauses AS (
    SELECT "top_causes"
    FROM CausesOccurrence
    WHERE "years_count" = 1
)
SELECT DISTINCT CAST(yt."db_year" AS INT) AS "Year"
FROM YearTopCauses yt
JOIN UniqueCauses uc ON yt."top_causes" = uc."top_causes";