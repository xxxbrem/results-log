WITH target_embedding AS (
  SELECT f.seq AS seq, f.value::FLOAT AS t_value
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB a,
       LATERAL FLATTEN(input => a."embedding_v1") f
  WHERE a."publication_number" = 'US-9741766-B2'
),
candidate_embeddings AS (
  SELECT p."publication_number", f.seq AS seq, f.value::FLOAT AS c_value
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p
  JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB a
    ON p."publication_number" = a."publication_number",
       LATERAL FLATTEN(input => a."embedding_v1") f
  WHERE p."filing_date" BETWEEN 20160101 AND 20161231
    AND a."embedding_v1" IS NOT NULL
    AND p."publication_number" <> 'US-9741766-B2'
)
SELECT c."publication_number"
FROM candidate_embeddings c
JOIN target_embedding t
  ON c.seq = t.seq
GROUP BY c."publication_number"
ORDER BY SUM(c.c_value * t.t_value) DESC NULLS LAST
LIMIT 5;