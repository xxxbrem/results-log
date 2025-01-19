WITH target_embedding AS (
  SELECT a."embedding_v1" AS "embedding"
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB a
  WHERE a."publication_number" = 'US-9741766-B2'
),

same_year_patents AS (
  SELECT p."publication_number", a."embedding_v1" AS "embedding"
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p
  JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB a ON p."publication_number" = a."publication_number"
  WHERE p."filing_date" IS NOT NULL
    AND EXTRACT(year FROM TRY_TO_DATE(p."filing_date"::VARCHAR, 'YYYYMMDD')) = (
        SELECT EXTRACT(year FROM TRY_TO_DATE("filing_date"::VARCHAR, 'YYYYMMDD'))
        FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS
        WHERE "publication_number" = 'US-9741766-B2'
    )
    AND p."publication_number" != 'US-9741766-B2'
    AND a."embedding_v1" IS NOT NULL
)

SELECT "publication_number"
FROM (
  SELECT s."publication_number",
        SUM(e1.value::FLOAT * e2.value::FLOAT) AS similarity
  FROM same_year_patents s,
  LATERAL FLATTEN(input => s."embedding") e2,
  target_embedding t,
  LATERAL FLATTEN(input => t."embedding") e1
  WHERE e1."INDEX" = e2."INDEX"
  GROUP BY s."publication_number"
  ORDER BY similarity DESC NULLS LAST
  LIMIT 5
)
;