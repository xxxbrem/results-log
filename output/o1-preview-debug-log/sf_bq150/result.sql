WITH expression_data AS (
  SELECT expr."case_barcode", 
         LOG(10, expr."normalized_count") AS log_expression,
         COALESCE(mut."Variant_Classification", 'Wild_Type') AS mutation_type
  FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM" AS expr
  LEFT JOIN (
    SELECT DISTINCT "case_barcode", "Variant_Classification"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3"
    WHERE "project_short_name" = 'TCGA-BRCA' AND "Hugo_Symbol" = 'TP53'
  ) AS mut ON expr."case_barcode" = mut."case_barcode"
  WHERE expr."project_short_name" = 'TCGA-BRCA' AND expr."HGNC_gene_symbol" = 'TP53'
    AND expr."normalized_count" IS NOT NULL AND expr."normalized_count" > 0
),
stats AS (
  SELECT
    COUNT(DISTINCT "case_barcode") AS Total_samples,
    COUNT(DISTINCT mutation_type) AS Number_of_mutation_types,
    AVG(log_expression) AS grand_mean
  FROM expression_data
),
group_stats AS (
  SELECT mutation_type, AVG(log_expression) AS group_mean, COUNT(*) AS n_j
  FROM expression_data
  GROUP BY mutation_type
),
ssb_calc AS (
  SELECT SUM(gs.n_j * POWER(gs.group_mean - s.grand_mean, 2)) AS SSB
  FROM group_stats gs CROSS JOIN stats s
),
ssw_calc AS (
  SELECT SUM(POWER(ed.log_expression - gs.group_mean, 2)) AS SSW
  FROM expression_data ed JOIN group_stats gs ON ed.mutation_type = gs.mutation_type
),
anova_stats AS (
  SELECT
    s.Total_samples,
    s.Number_of_mutation_types,
    s.Total_samples - s.Number_of_mutation_types AS df_within,
    s.Number_of_mutation_types - 1 AS df_between,
    ssb.SSB,
    ssw.SSW,
    ssb.SSB / (s.Number_of_mutation_types - 1) AS MSB,
    ssw.SSW / (s.Total_samples - s.Number_of_mutation_types) AS MSW,
    (ssb.SSB / (s.Number_of_mutation_types - 1)) / (ssw.SSW / (s.Total_samples - s.Number_of_mutation_types)) AS F_statistic
  FROM stats s CROSS JOIN ssb_calc ssb CROSS JOIN ssw_calc ssw
)
SELECT
  Total_samples,
  Number_of_mutation_types,
  ROUND(MSB, 4) AS "Mean_square_between_groups",
  ROUND(MSW, 4) AS "Mean_square_within_groups",
  ROUND(F_statistic, 4) AS "F_statistic"
FROM anova_stats;