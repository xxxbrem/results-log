WITH
patents AS (
  SELECT "publication_number", "citation"
  FROM PATENTS.PATENTS.PUBLICATIONS
  WHERE "country_code" = 'US' 
    AND "kind_code" = 'B2'
    AND "grant_date" BETWEEN 20150101 AND 20181231
),
citing_cited AS (
  SELECT t."publication_number" AS "patent_publication_number",
         cited.value:"publication_number"::STRING AS "cited_publication_number"
  FROM patents t,
  LATERAL FLATTEN(input => t."citation") cited
  WHERE cited.value:"publication_number" IS NOT NULL
),
cited_ipc AS (
  SELECT cc."patent_publication_number",
         cc."cited_publication_number",
         SUBSTR(ipc_item.value:"code"::STRING, 1, 4) AS "ipc4_code"
  FROM citing_cited cc
  LEFT JOIN PATENTS.PATENTS.PUBLICATIONS cited
    ON cc."cited_publication_number" = cited."publication_number"
  LEFT JOIN LATERAL FLATTEN(input => cited."ipc") ipc_item
  WHERE ipc_item.value:"code" IS NOT NULL
),
N_i_k AS (
  SELECT
    "patent_publication_number",
    "ipc4_code",
    COUNT(*) AS "N_i_k"
  FROM cited_ipc
  GROUP BY "patent_publication_number", "ipc4_code"
),
N_i_total AS (
  SELECT
    "patent_publication_number",
    SUM("N_i_k") AS "N_i_total"
  FROM N_i_k
  GROUP BY "patent_publication_number"
),
originality_scores AS (
  SELECT
    N_i_k."patent_publication_number",
    ROUND(1 - SUM( POWER( N_i_k."N_i_k" / N_i_total."N_i_total", 2 ) ), 4) AS "originality_score"
  FROM N_i_k
  JOIN N_i_total ON N_i_k."patent_publication_number" = N_i_total."patent_publication_number"
  GROUP BY N_i_k."patent_publication_number"
)
SELECT "patent_publication_number" AS "publication_number"
FROM originality_scores
ORDER BY "originality_score" DESC NULLS LAST
LIMIT 1;