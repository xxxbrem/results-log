WITH
expr_data AS (
  SELECT "case_barcode", LOG(10, "normalized_count") AS log_expression
  FROM TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
  WHERE "project_short_name" = 'TCGA-BRCA'
    AND "HGNC_gene_symbol" = 'TP53'
    AND "normalized_count" > 0
),
mutation_data AS (
  SELECT DISTINCT "case_barcode", "Variant_Classification"
  FROM TCGA_HG19_DATA_V0.TCGA_HG19_DATA_V0."SOMATIC_MUTATION_MC3"
  WHERE "project_short_name" = 'TCGA-BRCA'
    AND "Hugo_Symbol" = 'TP53'
    AND "Variant_Classification" IS NOT NULL
),
joined_data AS (
  SELECT e."case_barcode", e.log_expression,
    COALESCE(m."Variant_Classification", 'Wild_Type') AS mutation_type
  FROM expr_data e
  LEFT JOIN mutation_data m
    ON e."case_barcode" = m."case_barcode"
),
grand_mean AS (
  SELECT AVG(log_expression) AS grand_mean
  FROM joined_data
),
group_stats AS (
  SELECT mutation_type,
    COUNT(*) AS n_j,
    AVG(log_expression) AS mean_j
  FROM joined_data
  GROUP BY mutation_type
),
ssb AS (
  SELECT SUM(n_j * POWER(mean_j - (SELECT grand_mean FROM grand_mean), 2)) AS ssb
  FROM group_stats
),
sample_deviations AS (
  SELECT jd."case_barcode", jd.log_expression, jd.mutation_type, gs.mean_j,
    POWER(jd.log_expression - gs.mean_j, 2) AS sq_dev
  FROM joined_data jd
  JOIN group_stats gs ON jd.mutation_type = gs.mutation_type
),
ssw AS (
  SELECT SUM(sq_dev) AS ssw
  FROM sample_deviations
),
total_samples AS (
  SELECT COUNT(*) AS N FROM joined_data
),
number_of_mutation_types AS (
  SELECT COUNT(*) AS K FROM (
    SELECT DISTINCT mutation_type FROM joined_data
  ) t
),
degrees_of_freedom AS (
  SELECT
    ((SELECT K FROM number_of_mutation_types) - 1) AS df_between,
    ((SELECT N FROM total_samples) - (SELECT K FROM number_of_mutation_types)) AS df_within
),
mean_squares AS (
  SELECT
    (SELECT ssb FROM ssb) / df_between AS MSB,
    (SELECT ssw FROM ssw) / df_within AS MSW
  FROM degrees_of_freedom
),
f_statistic AS (
  SELECT MSB, MSW, MSB / MSW AS F_value
  FROM mean_squares
)
SELECT
  (SELECT N FROM total_samples) AS total_samples,
  (SELECT K FROM number_of_mutation_types) AS number_of_mutation_types,
  ROUND(MSB,4) AS mean_square_between_groups,
  ROUND(MSW,4) AS mean_square_within_groups,
  ROUND(F_value,4) AS F_statistic
FROM f_statistic;