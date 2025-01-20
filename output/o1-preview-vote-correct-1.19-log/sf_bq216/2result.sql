WITH target_embedding AS (
    SELECT parse_json("embedding_v1") AS emb
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB
    WHERE "publication_number" = 'US-9741766-B2'
),
other_patents AS (
    SELECT t1."publication_number", parse_json(t1."embedding_v1") AS emb
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB t1
    JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS t2
      ON t1."publication_number" = t2."publication_number"
    WHERE SUBSTRING(CAST(t2."filing_date" AS VARCHAR), 1, 4) = '2016'
      AND t1."embedding_v1" IS NOT NULL
      AND t1."publication_number" <> 'US-9741766-B2'
)
SELECT op."publication_number"
FROM target_embedding te
CROSS JOIN other_patents op,
     LATERAL FLATTEN(input => te.emb) f1,
     LATERAL FLATTEN(input => op.emb) f2
WHERE f1.seq = f2.seq
GROUP BY op."publication_number"
ORDER BY SUM(f1.value::FLOAT * f2.value::FLOAT) DESC NULLS LAST
LIMIT 5;