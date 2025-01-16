WITH expr AS (
  SELECT "sample_barcode", LOG(10, "normalized_count") AS "log_expression"
  FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM"
  WHERE "project_short_name" = 'TCGA-BRCA' AND "HGNC_gene_symbol" = 'TP53' AND "normalized_count" > 0
),
mutations AS (
  SELECT "sample_barcode_tumor", MIN("Variant_Classification") AS "Variant_Classification"
  FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_DCC"
  WHERE "project_short_name" = 'TCGA-BRCA' AND "Hugo_Symbol" = 'TP53'
  GROUP BY "sample_barcode_tumor"
),
data AS (
  SELECT expr."sample_barcode", expr."log_expression", mutations."Variant_Classification" AS "Mutation_Type"
  FROM expr
  JOIN mutations ON expr."sample_barcode" = mutations."sample_barcode_tumor"
),
grand_mean AS (
  SELECT AVG("log_expression") AS "grand_mean", COUNT(*) AS N
  FROM data
),
group_means AS (
  SELECT "Mutation_Type", COUNT(*) AS n_j, AVG("log_expression") AS mean_j
  FROM data
  GROUP BY "Mutation_Type"
),
SSB AS (
  SELECT SUM(group_means.n_j * POWER(group_means.mean_j - grand_mean."grand_mean", 2)) AS SSB
  FROM group_means, grand_mean
),
SSW AS (
  SELECT SUM(POWER(data."log_expression" - group_means.mean_j, 2)) AS SSW
  FROM data
  JOIN group_means ON data."Mutation_Type" = group_means."Mutation_Type"
),
Degrees AS (
  SELECT (SELECT COUNT(*) FROM group_means) - 1 AS df_between,
         grand_mean.N - (SELECT COUNT(*) FROM group_means) AS df_within
  FROM grand_mean
),
MS AS (
  SELECT SSB.SSB / Degrees.df_between AS MSB, SSW.SSW / Degrees.df_within AS MSW
  FROM SSB, SSW, Degrees
),
F_statistic AS (
  SELECT MS.MSB / MS.MSW AS F_value
  FROM MS
)
SELECT grand_mean.N AS total_samples,
       (SELECT COUNT(*) FROM group_means) AS number_of_mutation_types,
       ROUND(MS.MSB, 4) AS mean_square_between_groups,
       ROUND(MS.MSW, 4) AS mean_square_within_groups,
       ROUND(F_statistic.F_value, 4) AS F_statistic
FROM grand_mean, MS, F_statistic;