WITH
target_filing_year AS (
   SELECT FLOOR("filing_date" / 10000) AS filing_year
   FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS
   WHERE "publication_number" = 'US-9741766-B2'
),
target_embedding AS (
   SELECT f.index AS idx, f.value::FLOAT AS value
   FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB t,
        LATERAL FLATTEN(input => t."embedding_v1") f
   WHERE t."publication_number" = 'US-9741766-B2'
),
patents_same_year AS (
   SELECT p."publication_number", a."embedding_v1"
   FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p
   JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB a ON p."publication_number" = a."publication_number"
   JOIN target_filing_year tfy ON FLOOR(p."filing_date" / 10000) = tfy.filing_year
   WHERE a."embedding_v1" IS NOT NULL
     AND p."publication_number" <> 'US-9741766-B2'
),
patent_embeddings AS (
   SELECT p."publication_number", f.index AS idx, f.value::FLOAT AS value
   FROM patents_same_year p,
        LATERAL FLATTEN(input => p."embedding_v1") f
),
similarities AS (
   SELECT pe."publication_number",
          ROUND(SUM(te.value * pe.value), 4) AS similarity
   FROM target_embedding te
   JOIN patent_embeddings pe ON te.idx = pe.idx
   GROUP BY pe."publication_number"
)
SELECT "publication_number"
FROM similarities
ORDER BY similarity DESC NULLS LAST
LIMIT 5;