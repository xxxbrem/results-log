WITH target_embedding AS (
    SELECT "embedding_v1" AS "embedding"
    FROM "PATENTS_GOOGLE"."PATENTS_GOOGLE"."ABS_AND_EMB"
    WHERE "publication_number" = 'US-9741766-B2'
),
target_embedding_table AS (
    SELECT f.index AS idx, f.value::FLOAT AS value
    FROM target_embedding, LATERAL FLATTEN(input => target_embedding."embedding") f
),
patents_same_year AS (
    SELECT p."publication_number", p."filing_date", a."embedding_v1" AS "embedding"
    FROM "PATENTS_GOOGLE"."PATENTS_GOOGLE"."PUBLICATIONS" p
    JOIN "PATENTS_GOOGLE"."PATENTS_GOOGLE"."ABS_AND_EMB" a
        ON p."publication_number" = a."publication_number"
    WHERE TO_CHAR(p."filing_date") LIKE '2016%'
        AND a."embedding_v1" IS NOT NULL
        AND a."publication_number" <> 'US-9741766-B2'
),
patent_embeddings AS (
    SELECT p."publication_number", f.index AS idx, f.value::FLOAT AS value
    FROM patents_same_year p, LATERAL FLATTEN(input => p."embedding") f
)
SELECT
    pe."publication_number"
FROM target_embedding_table te
JOIN patent_embeddings pe
    ON te.idx = pe.idx
GROUP BY pe."publication_number"
ORDER BY SUM(te.value * pe.value) DESC NULLS LAST
LIMIT 5;