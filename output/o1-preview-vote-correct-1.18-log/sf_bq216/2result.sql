WITH target_data AS (
  SELECT
    p."publication_number",
    SUBSTR(CAST(p."filing_date" AS VARCHAR), 1, 4) AS "filing_year",
    a."embedding_v1"
  FROM
    PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS AS p
  JOIN
    PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB AS a
    ON p."publication_number" = a."publication_number"
  WHERE
    p."publication_number" = 'US-9741766-B2'
),
target_embedding AS (
  SELECT
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS "idx",
    f.VALUE::FLOAT AS "target_value"
  FROM
    target_data,
    LATERAL FLATTEN(input => target_data."embedding_v1") f
),
same_year_pubs AS (
  SELECT
    p."publication_number",
    a."embedding_v1"
  FROM
    PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS AS p
  JOIN
    PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB AS a
    ON p."publication_number" = a."publication_number"
  WHERE
    SUBSTR(CAST(p."filing_date" AS VARCHAR), 1, 4) = (SELECT "filing_year" FROM target_data)
    AND p."publication_number" != 'US-9741766-B2'
    AND a."embedding_v1" IS NOT NULL
),
flattened_embeddings AS (
  SELECT
    sp."publication_number",
    ROW_NUMBER() OVER (PARTITION BY sp."publication_number" ORDER BY (SELECT NULL)) - 1 AS "idx",
    f.VALUE::FLOAT AS "embedding_value"
  FROM
    same_year_pubs sp,
    LATERAL FLATTEN(input => sp."embedding_v1") f
),
joined_embeddings AS (
  SELECT
    fe."publication_number",
    fe."embedding_value",
    te."target_value",
    fe."embedding_value" * te."target_value" AS "product"
  FROM
    flattened_embeddings fe
  JOIN
    target_embedding te
    ON fe."idx" = te."idx"
),
dot_products AS (
  SELECT
    je."publication_number",
    SUM(je."product") AS "similarity_score"
  FROM
    joined_embeddings je
  GROUP BY
    je."publication_number"
),
top5 AS (
  SELECT
    dp."publication_number"
  FROM
    dot_products dp
  ORDER BY
    dp."similarity_score" DESC NULLS LAST
  LIMIT 5
)
SELECT
  "publication_number"
FROM
  top5;