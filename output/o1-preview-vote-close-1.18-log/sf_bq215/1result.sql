WITH target_patents AS (
    SELECT "publication_number", "citation"
    FROM PATENTS.PATENTS.PUBLICATIONS
    WHERE "country_code" = 'US'
      AND "kind_code" = 'B2'
      AND "grant_date" BETWEEN 20150101 AND 20181231
), target_citations AS (
    SELECT tp."publication_number" AS pub_number, c.value:"publication_number"::STRING AS c_pn
    FROM target_patents tp
    JOIN LATERAL FLATTEN(input => tp."citation") c
), total_citations AS (
    SELECT pub_number, COUNT(DISTINCT c_pn) AS NCITED_i
    FROM target_citations
    GROUP BY pub_number
), cited_ipc AS (
    SELECT tc.pub_number, tc.c_pn, f_ipc.value:"code"::STRING AS ipc_code
    FROM target_citations tc
    JOIN PATENTS.PATENTS.PUBLICATIONS p ON p."publication_number" = tc.c_pn
    JOIN LATERAL FLATTEN(input => p."ipc") f_ipc
), cited_ipc4 AS (
    SELECT pub_number, c_pn, SUBSTR(ipc_code, 1, 4) AS ipc4_code
    FROM cited_ipc
), ipc_counts AS (
    SELECT pub_number, ipc4_code, COUNT(DISTINCT c_pn) AS NCITED_i_k
    FROM cited_ipc4
    GROUP BY pub_number, ipc4_code
), originality_scores AS (
    SELECT 
        ic.pub_number AS "publication_number",
        ROUND(1 - SUM(POWER(ic.NCITED_i_k * 1.0 / tc.NCITED_i, 2)), 4) AS originality_score
    FROM ipc_counts ic
    JOIN total_citations tc ON ic.pub_number = tc.pub_number
    GROUP BY ic.pub_number
)
SELECT "publication_number"
FROM originality_scores
ORDER BY originality_score DESC NULLS LAST
LIMIT 1;