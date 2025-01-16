WITH expression_data AS (
  SELECT 
    expr."sample_barcode",
    LOG(10, expr."normalized_count") AS "log_expression",
    COALESCE(sm."mutation_type", 'Wildtype') AS "mutation_type"
  FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."RNASEQ_GENE_EXPRESSION_UNC_RSEM" AS expr
  LEFT JOIN (
    SELECT 
      "sample_barcode_tumor",
      CASE 
        WHEN MIN(CASE WHEN "Variant_Classification" = 'Missense_Mutation' THEN 1 ELSE 2 END) = 1 THEN 'Missense_Mutation'
        ELSE 'Other_Mutation'
      END AS "mutation_type"
    FROM "TCGA_HG19_DATA_V0"."TCGA_HG19_DATA_V0"."SOMATIC_MUTATION_MC3"
    WHERE
      "project_short_name" = 'TCGA-BRCA' AND 
      "Hugo_Symbol" = 'TP53'
    GROUP BY "sample_barcode_tumor"
  ) AS sm ON expr."sample_barcode" = sm."sample_barcode_tumor"
  WHERE
    expr."project_short_name" = 'TCGA-BRCA' AND 
    expr."HGNC_gene_symbol" = 'TP53' AND 
    expr."normalized_count" > 0
),
grand_mean AS (
  SELECT AVG("log_expression") AS "grand_mean" FROM expression_data
),
group_means AS (
  SELECT "mutation_type", AVG("log_expression") AS "group_mean", COUNT(*) AS "n_j"
  FROM expression_data
  GROUP BY "mutation_type"
),
ssb AS (
  SELECT SUM(group_means."n_j" * POWER(group_means."group_mean" - grand_mean."grand_mean", 2)) AS "ssb"
  FROM group_means, grand_mean
),
ssw AS (
  SELECT SUM(POWER(expression_data."log_expression" - group_means."group_mean", 2)) AS "ssw"
  FROM expression_data
  JOIN group_means ON expression_data."mutation_type" = group_means."mutation_type"
),
degrees_of_freedom AS (
  SELECT 
    (SELECT COUNT(DISTINCT "mutation_type") FROM expression_data) - 1 AS "df_between",
    (SELECT COUNT(*) FROM expression_data) - (SELECT COUNT(DISTINCT "mutation_type") FROM expression_data) AS "df_within"
),
mean_squares AS (
  SELECT
    ssb."ssb" / degrees_of_freedom."df_between" AS "mean_square_between_groups",
    ssw."ssw" / degrees_of_freedom."df_within" AS "mean_square_within_groups"
  FROM ssb, ssw, degrees_of_freedom
),
F_statistic AS (
  SELECT "mean_square_between_groups" / "mean_square_within_groups" AS "F_statistic"
  FROM mean_squares
),
final AS (
  SELECT
    (SELECT COUNT(*) FROM expression_data) AS "total_number_of_samples",
    (SELECT COUNT(DISTINCT "mutation_type") FROM expression_data) AS "number_of_mutation_types",
    ROUND(mean_squares."mean_square_between_groups", 4) AS "mean_square_between_groups",
    ROUND(mean_squares."mean_square_within_groups", 4) AS "mean_square_within_groups",
    ROUND(F_statistic."F_statistic", 4) AS "F_statistic"
  FROM mean_squares, F_statistic
)

SELECT * FROM final;