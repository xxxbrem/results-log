WITH target_filing_year AS (
  SELECT FLOOR("filing_date" / 10000) AS filing_year
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS
  WHERE "publication_number" = 'US-9741766-B2'
),
target_embedding AS (
  SELECT f.seq AS idx, f.value::float AS value
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB t,
       LATERAL FLATTEN(input => t."embedding_v1") f
  WHERE t."publication_number" = 'US-9741766-B2'
),
other_embeddings AS (
  SELECT t."publication_number", f.seq AS idx, f.value::float AS value
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p
       JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB t
         ON p."publication_number" = t."publication_number"
       JOIN target_filing_year tfy ON FLOOR(p."filing_date" / 10000) = tfy.filing_year,
       LATERAL FLATTEN(input => t."embedding_v1") f
  WHERE t."embedding_v1" IS NOT NULL
    AND t."publication_number" <> 'US-9741766-B2'
),
dot_products AS (
  SELECT oe."publication_number",
         SUM(ROUND(oe.value * te.value, 4)) AS dot_product
  FROM other_embeddings oe
       JOIN target_embedding te ON oe.idx = te.idx
  GROUP BY oe."publication_number"
),
top5 AS (
  SELECT "publication_number"
  FROM dot_products
  ORDER BY dot_product DESC NULLS LAST, "publication_number"
  LIMIT 5
)
SELECT "publication_number"
FROM top5;