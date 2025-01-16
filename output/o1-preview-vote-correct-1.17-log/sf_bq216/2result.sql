WITH target_cpc AS (
    SELECT
        cpc.value:"code"::STRING AS "cpc_code"
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p,
         LATERAL FLATTEN(input => p."cpc") cpc
    WHERE p."publication_number" = 'US-9741766-B2'
),

other_patents_cpc AS (
    SELECT
        p."publication_number",
        cpc.value:"code"::STRING AS "cpc_code"
    FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS p,
         LATERAL FLATTEN(input => p."cpc") cpc
    WHERE FLOOR(p."filing_date" / 10000) = 2016
      AND p."publication_number" != 'US-9741766-B2'
),

shared_cpc_counts AS (
    SELECT
        o."publication_number",
        COUNT(*) AS "shared_cpc_count"
    FROM other_patents_cpc o
    JOIN target_cpc t ON o."cpc_code" = t."cpc_code"
    GROUP BY o."publication_number"
)

SELECT s."publication_number"
FROM shared_cpc_counts s
ORDER BY s."shared_cpc_count" DESC NULLS LAST
LIMIT 5;