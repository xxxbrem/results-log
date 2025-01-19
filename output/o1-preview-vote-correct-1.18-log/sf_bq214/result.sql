WITH focal_pats AS (
    SELECT 
        p."publication_number" AS focal_pub_num, 
        p."filing_date" AS focal_filing_date,
        TO_DATE(p."filing_date"::VARCHAR, 'YYYYMMDD') AS focal_filing_date_dt
    FROM 
        PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p 
    WHERE 
        p."country_code" = 'US' 
        AND p."kind_code" = 'B2' 
        AND p."grant_date" BETWEEN 20100101 AND 20141231
        AND p."filing_date" IS NOT NULL
        AND p."filing_date" != 0
),
citing_pats AS (
    SELECT 
        cp."publication_number" AS citing_pub_num, 
        cp."filing_date" AS citing_filing_date,
        TO_DATE(cp."filing_date"::VARCHAR, 'YYYYMMDD') AS citing_filing_date_dt,
        cf.VALUE:"publication_number"::STRING AS cited_pub_num
    FROM 
        PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS cp,
        LATERAL FLATTEN(input => cp."citation") cf
    WHERE 
        cp."filing_date" IS NOT NULL
        AND cp."filing_date" != 0
),
citations_within_one_month AS (
    SELECT 
        f.focal_pub_num,
        COUNT(*) AS citation_count,
        f.focal_filing_date_dt
    FROM 
        focal_pats f 
        JOIN citing_pats c
            ON c.cited_pub_num = f.focal_pub_num
            AND c.citing_filing_date_dt BETWEEN f.focal_filing_date_dt AND DATEADD(day, 30, f.focal_filing_date_dt)
    GROUP BY 
        f.focal_pub_num,
        f.focal_filing_date_dt
),
best_patent AS (
    SELECT
        f.focal_pub_num,
        f.focal_filing_date_dt
    FROM
        citations_within_one_month f
    ORDER BY
        citation_count DESC NULLS LAST
    LIMIT 1
),
focal_embedding AS (
    SELECT
        ae."embedding_v1" AS focal_embedding
    FROM
        PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB ae
        JOIN best_patent bp ON ae."publication_number" = bp.focal_pub_num
    WHERE
        ae."embedding_v1" IS NOT NULL
),
candidate_pats AS (
    SELECT
        p."publication_number",
        ae."embedding_v1"
    FROM
        PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p
        JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB ae ON p."publication_number" = ae."publication_number"
    WHERE
        p."filing_date" IS NOT NULL
        AND p."filing_date" != 0
        AND EXTRACT(year FROM TO_DATE(p."filing_date"::VARCHAR, 'YYYYMMDD')) = EXTRACT(year FROM (SELECT focal_filing_date_dt FROM best_patent))
        AND ae."embedding_v1" IS NOT NULL
        AND p."publication_number" <> (SELECT focal_pub_num FROM best_patent)
),
similarity_calculations AS (
    SELECT
        c."publication_number" AS candidate_pub_num,
        SUM(f_e.VALUE::FLOAT * c_e.VALUE::FLOAT) AS similarity_score
    FROM
        candidate_pats c
        CROSS JOIN focal_embedding f,
        LATERAL FLATTEN(input => c."embedding_v1") c_e,
        LATERAL FLATTEN(input => f.focal_embedding) f_e
    WHERE
        c_e.SEQ = f_e.SEQ
    GROUP BY
        c."publication_number"
),
most_similar_patent AS (
    SELECT
        candidate_pub_num
    FROM
        similarity_calculations
    ORDER BY
        similarity_score DESC NULLS LAST
    LIMIT 1
)
SELECT
    (SELECT focal_pub_num FROM best_patent) AS Focal_patent_number,
    candidate_pub_num AS Most_similar_patent_number
FROM
    most_similar_patent;