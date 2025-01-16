WITH expression_data AS (
  SELECT
    "case_barcode",
    "sample_barcode",
    LOG(10, "normalized_count") AS log_expression
  FROM
    TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
  WHERE
    "project_short_name" = 'TCGA-BRCA'
    AND "HGNC_gene_symbol" = 'TP53'
    AND "normalized_count" > 0
),
mutation_data AS (
  SELECT DISTINCT
    "case_barcode",
    "sample_barcode_tumor",
    "Variant_Classification" AS mutation_type
  FROM
    TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0."SOMATIC_MUTATION_MC3"
  WHERE
    "project_short_name" = 'TCGA-BRCA'
    AND "Hugo_Symbol" = 'TP53'
),
sample_data AS (
  SELECT
    e."case_barcode",
    e."sample_barcode",
    e.log_expression,
    COALESCE(m.mutation_type, 'No_Mutation') AS mutation_type
  FROM
    expression_data e
  LEFT JOIN
    mutation_data m
  ON
    e."case_barcode" = m."case_barcode"
),
grand_mean AS (
  SELECT AVG(log_expression) AS grand_mean
  FROM sample_data
),
group_stats AS (
  SELECT
    mutation_type,
    COUNT(*) AS n_j,
    AVG(log_expression) AS group_mean
  FROM
    sample_data
  GROUP BY
    mutation_type
),
ssb AS (
  SELECT SUM(n_j * POWER(group_mean - (SELECT grand_mean FROM grand_mean), 2)) AS ssb_value
  FROM group_stats
),
sample_with_group_mean AS (
  SELECT
    s.*,
    g.group_mean
  FROM
    sample_data s
  JOIN
    group_stats g
  ON
    s.mutation_type = g.mutation_type
),
ssw AS (
  SELECT SUM(POWER(log_expression - group_mean, 2)) AS ssw_value
  FROM sample_with_group_mean
),
total_samples AS (
  SELECT COUNT(*) AS total_samples FROM sample_data
),
mutation_types AS (
  SELECT COUNT(*) AS mutation_types FROM group_stats
),
mean_squares AS (
  SELECT
    (SELECT ssb_value FROM ssb) / (mt.mutation_types - 1) AS msb,
    (SELECT ssw_value FROM ssw) / (ts.total_samples - mt.mutation_types) AS msw
  FROM
    total_samples ts,
    mutation_types mt
)
SELECT
  ts.total_samples,
  mt.mutation_types,
  ROUND(ms.msb, 4) AS mean_square_between_groups,
  ROUND(ms.msw, 4) AS mean_square_within_groups,
  ROUND(ms.msb / ms.msw, 4) AS F_statistic
FROM
  total_samples ts,
  mutation_types mt,
  mean_squares ms;