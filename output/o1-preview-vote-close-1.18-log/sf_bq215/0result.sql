WITH citing_patents AS (
    SELECT 
        p."publication_number" AS citing_pub_num,
        f.value:"publication_number"::STRING AS cited_pub_num
    FROM 
        PATENTS.PATENTS.PUBLICATIONS p,
        LATERAL FLATTEN(input => p."citation") f
    WHERE
        p."country_code" = 'US' AND
        p."kind_code" = 'B2' AND
        p."grant_date" BETWEEN 20150101 AND 20181231
        AND f.value:"publication_number"::STRING IS NOT NULL
),
cited_ipc_codes AS (
    SELECT 
        p."publication_number" AS cited_pub_num,
        SUBSTR(f.value:"code"::STRING, 1, 4) AS cited_ipc4_code
    FROM 
        PATENTS.PATENTS.PUBLICATIONS p,
        LATERAL FLATTEN(input => p."ipc") f
    WHERE 
        p."publication_number" IN (SELECT DISTINCT cited_pub_num FROM citing_patents)
        AND f.value:"code"::STRING IS NOT NULL
),
citing_cited_ipc AS (
    SELECT 
        cp.citing_pub_num,
        ci.cited_ipc4_code
    FROM 
        citing_patents cp
        JOIN cited_ipc_codes ci ON cp.cited_pub_num = ci.cited_pub_num
),
ipc_class_counts AS (
    SELECT 
        citing_pub_num,
        cited_ipc4_code,
        COUNT(*) AS n_ij
    FROM 
        citing_cited_ipc
    GROUP BY 
        citing_pub_num, cited_ipc4_code
),
total_citations AS (
    SELECT 
        citing_pub_num,
        SUM(n_ij) AS N_i
    FROM 
        ipc_class_counts
    GROUP BY 
        citing_pub_num
),
originality_scores AS (
    SELECT 
        i.citing_pub_num,
        1 - SUM(POWER(i.n_ij * 1.0 / t.N_i, 2)) AS originality_score
    FROM 
        ipc_class_counts i
        JOIN total_citations t ON i.citing_pub_num = t.citing_pub_num
    GROUP BY 
        i.citing_pub_num
)
SELECT 
    citing_pub_num AS publication_number,
    ROUND(originality_score, 4) AS originality_score
FROM 
    originality_scores
ORDER BY 
    originality_score DESC NULLS LAST
LIMIT 1;