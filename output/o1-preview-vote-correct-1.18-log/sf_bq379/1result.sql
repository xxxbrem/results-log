WITH psoriasis_associations AS (
    SELECT "targetId", ROUND("score", 4) AS score
    FROM "OPEN_TARGETS_PLATFORM_1"."PLATFORM"."ASSOCIATIONBYOVERALLDIRECT"
    WHERE "diseaseId" = 'EFO_0000676' AND "score" IS NOT NULL
),
mean_score AS (
    SELECT ROUND(AVG(score), 4) AS avg_score FROM psoriasis_associations
),
closest_target AS (
    SELECT "targetId", score, ABS(score - (SELECT avg_score FROM mean_score)) AS delta
    FROM psoriasis_associations
    ORDER BY delta
    LIMIT 1
)
SELECT t."approvedSymbol"
FROM closest_target ct
JOIN "OPEN_TARGETS_PLATFORM_1"."PLATFORM"."TARGETS" t ON ct."targetId" = t."id";