WITH expr AS (
  SELECT "sample_barcode", LOG(10, "normalized_count") AS log_expression
  FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
  WHERE "project_short_name" = 'TCGA-BRCA' AND "HGNC_gene_symbol" = 'TP53' AND "normalized_count" > 0
),
mut AS (
  SELECT DISTINCT "sample_barcode_tumor" AS "sample_barcode", "Variant_Classification"
  FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3"
  WHERE "project_short_name" = 'TCGA-BRCA' AND "Hugo_Symbol" = 'TP53'
),
expr_mut AS (
  SELECT e."sample_barcode", e.log_expression,
    COALESCE(m."Variant_Classification", 'No Mutation') AS "Mutation_Type"
  FROM expr e
  LEFT JOIN mut m ON e."sample_barcode" = m."sample_barcode"
),
grand_mean AS (
  SELECT AVG(log_expression) AS X_bar, COUNT(*) AS N
  FROM expr_mut
),
group_stats AS (
  SELECT "Mutation_Type", COUNT(*) AS n_j, AVG(log_expression) AS mean_j
  FROM expr_mut
  GROUP BY "Mutation_Type"
),
SSB AS (
  SELECT SUM(gs.n_j * POWER(gs.mean_j - gm.X_bar,2)) AS SSB_total
  FROM group_stats gs, grand_mean gm
),
SSW AS (
  SELECT SUM(POWER(em.log_expression - gs.mean_j,2)) AS SSW_total
  FROM expr_mut em
  JOIN group_stats gs ON em."Mutation_Type" = gs."Mutation_Type"
),
df AS (
  SELECT 
    (SELECT COUNT(*) FROM group_stats) - 1 AS df_between,
    (SELECT N FROM grand_mean) - (SELECT COUNT(*) FROM group_stats) AS df_within
),
MS AS (
  SELECT 
    (SELECT SSB_total FROM SSB) / df.df_between AS MSB_value,
    (SELECT SSW_total FROM SSW) / df.df_within AS MSW_value
  FROM df
),
F_statistic AS (
  SELECT MSB_value / MSW_value AS F_value
  FROM MS
)
SELECT
  (SELECT N FROM grand_mean) AS total_samples,
  (SELECT COUNT(*) FROM group_stats) AS number_of_mutation_types,
  ROUND((SELECT MSB_value FROM MS), 4) AS mean_square_between_groups,
  ROUND((SELECT MSW_value FROM MS), 4) AS mean_square_within_groups,
  ROUND((SELECT F_value FROM F_statistic), 4) AS F_statistic;