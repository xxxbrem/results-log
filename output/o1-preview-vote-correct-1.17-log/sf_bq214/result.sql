WITH PubDates AS (
    SELECT "publication_number",
        CASE 
            WHEN "filing_date" IS NOT NULL AND "filing_date" != 0 
            THEN TO_DATE(CAST("filing_date" AS VARCHAR), 'YYYYMMDD') 
            ELSE NULL 
        END AS "filing_date",
        CASE 
            WHEN "grant_date" IS NOT NULL AND "grant_date" != 0 
            THEN TO_DATE(CAST("grant_date" AS VARCHAR), 'YYYYMMDD') 
            ELSE NULL 
        END AS "grant_date",
        CASE 
            WHEN "filing_date" IS NOT NULL AND "filing_date" != 0 
            THEN TO_CHAR(TO_DATE(CAST("filing_date" AS VARCHAR), 'YYYYMMDD'), 'YYYY') 
            ELSE NULL 
        END AS "filing_year"
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS
),
P AS (
    SELECT pd."publication_number", 
           pd."filing_date",
           pd."grant_date",
           pd."filing_year"
    FROM PubDates pd
    JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p ON pd."publication_number" = p."publication_number"
    WHERE p."country_code" = 'US' 
      AND p."kind_code" = 'B2' 
      AND pd."filing_date" IS NOT NULL
      AND pd."grant_date" IS NOT NULL
      AND pd."grant_date" BETWEEN '2010-01-01' AND '2014-12-31'
),
Citations AS (
    SELECT t."publication_number" AS "citing_publication_number", 
           cv.value:"publication_number"::STRING AS "cited_publication_number"
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS t, 
         LATERAL FLATTEN(input => t."citation") cv
    WHERE cv.value:"publication_number" IS NOT NULL
),
ForwardCitations AS (
    SELECT c."cited_publication_number" AS "publication_number",
           c."citing_publication_number"
    FROM Citations c
    JOIN P ON c."cited_publication_number" = P."publication_number"
),
CitingPatents AS (
    SELECT fc."publication_number", fc."citing_publication_number", 
           CASE 
               WHEN cp."filing_date" IS NOT NULL AND cp."filing_date" != 0 
               THEN TO_DATE(CAST(cp."filing_date" AS VARCHAR), 'YYYYMMDD') 
               ELSE NULL 
           END AS "citing_filing_date"
    FROM ForwardCitations fc
    JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS cp
    ON fc."citing_publication_number" = cp."publication_number"
    WHERE cp."filing_date" IS NOT NULL AND cp."filing_date" != 0
),
FinalCounts AS (
    SELECT p."publication_number", p."filing_date", p."grant_date", p."filing_year",
           COUNT(cp."citing_publication_number") AS "number_of_forward_citations_within_a_month"
    FROM P p
    LEFT JOIN CitingPatents cp
    ON p."publication_number" = cp."publication_number"
    AND cp."citing_filing_date" BETWEEN p."filing_date" AND DATEADD(month, 1, p."filing_date")
    GROUP BY p."publication_number", p."filing_date", p."grant_date", p."filing_year"
),
-- Get the patent with the most forward citations within a month
TargetPatent AS (
    SELECT p.*
    FROM FinalCounts p
    WHERE p."filing_date" IS NOT NULL
    ORDER BY p."number_of_forward_citations_within_a_month" DESC NULLS LAST
    LIMIT 1
),
Variables AS (
    SELECT tp."publication_number" AS target_pub_num, tp."filing_year" AS target_filing_year
    FROM TargetPatent tp
),
PatentEmbeddings AS (
    SELECT pe_base."publication_number", 
           ROW_NUMBER() OVER (PARTITION BY pe_base."publication_number" ORDER BY pe.seq) AS idx,
           pe.value::FLOAT AS val
    FROM (
        SELECT p."publication_number", emb."embedding_v1", pd."filing_year"
        FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p
        JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB emb 
          ON p."publication_number" = emb."publication_number"
        JOIN PubDates pd ON p."publication_number" = pd."publication_number"
        CROSS JOIN Variables v
        WHERE pd."filing_year" = v.target_filing_year
          AND p."publication_number" != v.target_pub_num
    ) pe_base
    , LATERAL FLATTEN(input => pe_base."embedding_v1") pe
),
TargetEmbedding AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY te.seq) AS idx,
        te.value::FLOAT AS val
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB emb
    CROSS JOIN Variables v
    , LATERAL FLATTEN(input => emb."embedding_v1") te
    WHERE emb."publication_number" = v.target_pub_num
),
Similarities AS (
    SELECT pe."publication_number",
           SUM(pe.val * te.val) AS "similarity_score"
    FROM PatentEmbeddings pe
    JOIN TargetEmbedding te ON pe.idx = te.idx
    GROUP BY pe."publication_number"
    ORDER BY "similarity_score" DESC NULLS LAST
    LIMIT 1
)
SELECT
    tp."publication_number",
    TO_CHAR(tp."filing_date",'YYYY-MM-DD') AS "filing_date",
    TO_CHAR(tp."grant_date",'YYYY-MM-DD') AS "grant_date",
    tp."number_of_forward_citations_within_a_month",
    s."publication_number" AS "similar_patent_publication_number",
    ROUND(s."similarity_score", 4) AS "similarity_score"
FROM TargetPatent tp, Similarities s;