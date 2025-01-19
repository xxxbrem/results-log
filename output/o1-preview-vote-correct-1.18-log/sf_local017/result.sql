WITH YearlyTopCauses AS (
    SELECT
        SUBSTR("collision_date", 1, 4) AS "Year",
        "pcf_violation_category",
        COUNT(*) AS "Count",
        DENSE_RANK() OVER (
            PARTITION BY SUBSTR("collision_date", 1, 4)
            ORDER BY COUNT(*) DESC
        ) AS "Rank"
    FROM "CALIFORNIA_TRAFFIC_COLLISION"."CALIFORNIA_TRAFFIC_COLLISION"."COLLISIONS"
    WHERE "pcf_violation_category" IS NOT NULL AND "pcf_violation_category" <> ''
    GROUP BY SUBSTR("collision_date", 1, 4), "pcf_violation_category"
),
YearlyTopTwoCauses AS (
    SELECT
        "Year",
        "pcf_violation_category",
        "Count"
    FROM YearlyTopCauses
    WHERE "Rank" <= 2
),
YearlyTopCausesString AS (
    SELECT
        "Year",
        LISTAGG("pcf_violation_category", ',') WITHIN GROUP (ORDER BY "pcf_violation_category") AS "Top_Causes"
    FROM YearlyTopTwoCauses
    GROUP BY "Year"
),
CausesGroupCounts AS (
    SELECT
        "Top_Causes",
        COUNT(*) AS "YearsCount"
    FROM YearlyTopCausesString
    GROUP BY "Top_Causes"
    ORDER BY "YearsCount" DESC NULLS LAST
),
MostCommonTopCauses AS (
    SELECT "Top_Causes"
    FROM CausesGroupCounts
    ORDER BY "YearsCount" DESC NULLS LAST
    LIMIT 1
),
DifferentYears AS (
    SELECT YearlyTopCausesString."Year"
    FROM YearlyTopCausesString
    WHERE YearlyTopCausesString."Top_Causes" NOT IN (SELECT "Top_Causes" FROM MostCommonTopCauses)
)
SELECT "Year"
FROM DifferentYears
ORDER BY "Year";