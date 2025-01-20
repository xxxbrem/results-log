WITH target_filing_year AS (
    SELECT EXTRACT(YEAR FROM TRY_TO_DATE("filing_date"::VARCHAR, 'YYYYMMDD')) AS "filing_year"
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS
    WHERE "publication_number" = 'US-9741766-B2'
),
target_embedding AS (
    SELECT f.seq AS idx, f.value::FLOAT AS val
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB t
    , LATERAL FLATTEN(input => t."embedding_v1") f
    WHERE t."publication_number" = 'US-9741766-B2'
),
same_year_patents AS (
    SELECT p."publication_number"
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p
    INNER JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB a
    ON p."publication_number" = a."publication_number"
    WHERE EXTRACT(YEAR FROM TRY_TO_DATE(p."filing_date"::VARCHAR, 'YYYYMMDD')) = 
    (SELECT "filing_year" FROM target_filing_year)
    AND p."publication_number" <> 'US-9741766-B2'
),
patent_similarity AS (
    SELECT pwe."publication_number", ROUND(SUM(pwe.val * te.val), 4) AS similarity_score
    FROM (
        SELECT a."publication_number", f.seq AS idx, f.value::FLOAT AS val
        FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB a
        INNER JOIN same_year_patents p ON a."publication_number" = p."publication_number"
        , LATERAL FLATTEN(input => a."embedding_v1") f
    ) pwe
    JOIN target_embedding te ON pwe.idx = te.idx
    GROUP BY pwe."publication_number"
)
SELECT "publication_number"
FROM patent_similarity
ORDER BY similarity_score DESC NULLS LAST
LIMIT 5